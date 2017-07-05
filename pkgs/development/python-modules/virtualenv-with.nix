{ stdenv, buildEnv, python, virtualenv, pythonPackages }:

{ packages
, buildInputs ? []
, installPackages ? (p: [])
, installHook ? ""
, shellHook ? ""
}:

let

  inherit (stdenv.lib) concatStringsSep;
  inherit (python) sitePackages;

  pythonInputs = installPackages pythonPackages;
  pythonWheels = map (pkg: "${pkg.wheelhouse}/*.whl") pythonInputs;

  pythonEnv = buildEnv {
    name = "${python.name}-environment";
    paths = packages pythonPackages;
  };

  env = stdenv.mkDerivation {
    name = "${python.name}-user-environment";

    buildInputs = [ pythonEnv ] ++ pythonInputs ++ buildInputs;

    SOURCE_DATE_EPOCH = "315542800";

    shellHook = ''
      export PATH="$PWD/venv/bin''${PATH:+:}$PATH"
      export PYTHONPATH="${pythonEnv}/${sitePackages}:$PWD/venv/${sitePackages}''${PYTHONPATH:+:}$PYTHONPATH"

      if ! test -d venv; then
        ${virtualenv}/bin/virtualenv venv
        pip install ${concatStringsSep " " pythonWheels} -I --no-deps

        ${installHook}
      fi

      ${shellHook}
    '';
  };

in
  env
