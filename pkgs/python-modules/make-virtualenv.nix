{ stdenv, buildEnv, mkShell, python, virtualenv, pythonPlatform, pythonScope }:

{ withPackages
, pythonTools ? [], pythonDepends ? []
, systemDepends ? []
, buildInputs ? []
, installHook ? "", pipFlags ? ""
, shellHook ? ""
}:

let
  pkgs = withPackages pythonScope;

  env = buildEnv {
    name = "${python.name}-environment";
    paths = pkgs ++ pythonDepends;
    pathsToLink = [ "/lib" ];

    postBuild = ''
      mkdir -p $out/bin
      for dep in ${stdenv.lib.concatStringsSep " " (pkgs ++ pythonTools)}; do
          for f in $dep/bin/*; do
              substitute $f $out/bin/''${f##*/} \
                  --replace '#!${python}/bin/' '#!/usr/bin/env '
              chmod +x $out/bin/''${f##*/}
          done
      done
    '';
  };
in

mkShell {
  name = "${python.name}-shell-environment";
  inherit env pipFlags;
  buildInputs = [ env ] ++ systemDepends ++ buildInputs;

  shellHook = ''
    prefix=$PWD/venv
    profile=$prefix/nix-profile

    addToSearchPath PATH $prefix/bin

    if ! test -e $profile; then
        ${virtualenv}/bin/virtualenv $prefix --no-download
        substituteInPlace $prefix/bin/activate \
            --replace '$VIRTUAL_ENV/bin' '$VIRTUAL_ENV/bin:$VIRTUAL_ENV/nix-profile/bin'

        if [ -n "$pipFlags" ]; then
            pip install $pipFlags -I --no-deps --disable-pip-version-check
        fi
        ${installHook}
    fi

    if test ${env} != "$(readlink $profile)"; then
        rm $profile 2> /dev/null || true
        echo ${env}/${pythonPlatform.sitePackages} > $prefix/${pythonPlatform.sitePackages}/${env.name}.pth
        nix-store -r ${env} --indirect --add-root $profile > /dev/null
    fi

    ${shellHook}
  '';
}
