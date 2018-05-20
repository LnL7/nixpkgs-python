{ stdenv, buildEnv, python, pythonPlatform, pythonScope }:

{ withPackages
, pythonTools ? [], pythonDepends ? []
}:

let
  pkgs = withPackages pythonScope;
in

buildEnv {
  name = "${pythonPlatform.abi}-environment";
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
}
