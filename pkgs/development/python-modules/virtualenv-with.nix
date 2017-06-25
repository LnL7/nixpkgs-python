{ stdenv, buildEnv, python, virtualenv, pythonPackages }:

{ packages
, buildInputs ? []
, installPackages ? (p: [])
, installHook ? ""
, shellHook ? ""
}:

let

  inherit (stdenv.lib) concatMapStringsSep;
  inherit (python) sitePackages;

  pythonInputs = installPackages pythonPackages;

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
        pip install ${concatMapStringsSep " " (x: "${x.src}/${x.src.pipWheels}/*") pythonInputs} -I --no-deps

        ${installHook}
      fi

      ${shellHook}
    '';
  };

in
  env
