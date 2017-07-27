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
      export PATH="$PWD/venv/bin:$PWD/venv/nix-profile/bin''${PATH:+:}$PATH"
      export PYTHONPATH="$PWD/venv/${sitePackages}:$PWD/venv/nix-profile/${sitePackages}''${PYTHONPATH:+:}$PYTHONPATH"

      mkdir -p venv
      if test -L venv/nix-profile; then rm venv/nix-profile; fi
      nix-store -r ${pythonEnv} --indirect --add-root $PWD/venv/nix-profile > /dev/null

      if ! test -e venv/bin/activate; then
        ${virtualenv}/bin/virtualenv venv
        pip install ${concatStringsSep " " pythonWheels} -I --no-deps

        ${installHook}
      fi

      ${shellHook}
    '';
  };

in
  env
