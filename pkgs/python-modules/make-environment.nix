{ stdenv, lndir, python, pythonPlatform, pythonScope }:

{ name ? "${pythonPlatform.python}-environment"
, withPackages ? p: []
, pythonTools ? [], pythonDepends ? []
, nativeBuildInputs ? []
, dontDetectConflicts ? false
, ...
}@attrs:

let
  pkgs = withPackages pythonScope;
in

stdenv.mkDerivation (attrs // {
  inherit name;
  nativeBuildInputs = [ lndir python ] ++ nativeBuildInputs;

  pythonDepends = pkgs ++ pythonDepends;
  pythonTools = pkgs ++ pythonTools;

  buildCommand = ''
    mkdir -p $out/${pythonPlatform.sitePackages}

    for dep in $pythonDepends; do
        lndir $dep/${pythonPlatform.sitePackages} $out/${pythonPlatform.sitePackages}
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
