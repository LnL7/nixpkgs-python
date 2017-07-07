{ stdenv, buildEnv, python, virtualenv, pythonPackages }:

{ packages
, buildInputs ? []
, shellHook ? ""
}:

let

  inherit (python) sitePackages;

  pythonEnv = buildEnv {
    name = "${python.name}-environment";
    paths = packages pythonPackages;
  };

  env = stdenv.mkDerivation {
    name = "${python.name}-user-environment";

    buildInputs = [ python pythonEnv ] ++ buildInputs;

    SOURCE_DATE_EPOCH = "315542800";

    shellHook = ''
      export PYTHONPATH="${pythonEnv}/${sitePackages}''${PYTHONPATH:+:}$PYTHONPATH"

      ${shellHook}
    '';
  };

in
  env
