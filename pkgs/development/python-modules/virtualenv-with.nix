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

      mkdir -p venv/${sitePackages}

      if test ${pythonEnv} != "$(readlink venv/nix-profile)"; then
        rm venv/nix-profile 2> /dev/null || true
        echo ${pythonEnv}/${sitePackages} > venv/${sitePackages}/${pythonEnv.name}.pth
        nix-store -r ${pythonEnv} --indirect --add-root $PWD/venv/nix-profile > /dev/null
      fi

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
