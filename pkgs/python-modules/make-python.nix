{ stdenv, buildEnv, python, pythonPlatform, pythonScope }:

{ withPackages ? p: []
, pythonTools ? [], pythonDepends ? []
}:

let
  self = buildEnv {
    name = "${python.name}-with-packages";
    paths = [ python ] ++ withPackages pythonScope ++ pythonDepends;
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

      for dep in ${stdenv.lib.concatStringsSep " " pythonTools}; do
          for f in $dep/bin/*; do
              substitute $f $out/bin/''${f##*/} \
                  --replace "#!${python}/bin/" "#!$out/bin/"
              chmod +x $out/bin/''${f##*/}
          done
      done
    '';

    passthru = {
      inherit (python) pip;
      mkDerivation = python.mkDerivation.override { python = self; };
    };
  };
in
  self
