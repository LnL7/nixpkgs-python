{ stdenv, python, pythonPlatform, pythonScope }:

{ name ? "${pythonPlatform.python}-environment"
, withPackages ? p: []
, pythonTools ? [], pythonDepends ? []
, dontDetectConflicts ? false
, ...
}@attrs:

let
  pkgs = withPackages pythonScope;
in

stdenv.mkDerivation (attrs // {
  inherit name;
  buildInputs = [ python ];

  pythonDepends = pkgs ++ pythonDepends;
  pythonTools = pkgs ++ pythonTools;

  buildCommand = ''
    for dep in $pythonDepends; do
        for f in $(find $dep/${pythonPlatform.sitePackages} -type f -o -type l); do
            l=''${f/$dep/$out}
            f=$(readlink -f "$f")
            if [ -s "$l" ]; then
                continue
            fi
            if [ -L "$l" ]; then
                l=$(readlink -f "$f")
                if [ "$f" = "$l" ]; then
                    continue
                fi
            fi
            mkdir -p "$(dirname "$l")"
            ln -s "$f" "$l"
        done
    done

    if [ -z "''${dontDetectConflicts:-}" ]; then
        ${pythonPlatform.python} ${./pip/detect_conflicts.py} $out/${pythonPlatform.sitePackages}/*.dist-info
    fi

    for dep in $pythonTools; do
        for f in $dep/bin/*; do
            mkdir -p $out/bin
            substitute $f $out/bin/''${f##*/} \
                --replace '#!${python}/bin/' '#!/usr/bin/env '
            chmod +x $out/bin/''${f##*/}
        done
    done
  '';
})
