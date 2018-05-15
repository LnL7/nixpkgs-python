{ stdenv, buildEnv, python, pythonPlatform, pythonScope }:

{ withPackages
}:

let
  pythonDepends = withPackages pythonScope;

  self = buildEnv {
    name = "${python.name}-with-packages";
    paths = [ python ] ++ pythonDepends;
    pathsToLink = [ "/lib" ];

    postBuild = ''
      mkdir -p $out/bin
      python=${python}
      for f in $python/bin/*; do
          if [ -L $f ]; then
              l=$(readlink -f $f)
              ln -s ''${l/$python/$out} $out/bin/''${f##*/}
          else
              cp $f $out/bin
          fi
      done
    '';

    passthru = {
      inherit (python) pip;
      mkDerivation = python.mkDerivation.override { python = self; };
    };
  };
in
  self
