{ stdenv, buildEnv, python, virtualenv
, interpreter, packages, pythonPlatform
}:

{ extend ? (self: super: {})
, pythonDepends ? []
, buildInputs ? []
, installHook ? "", pipFlags ? ""
, shellHook ? ""
}:

pythonFun:

let
  inherit (stdenv.lib) concatStringsSep;
  inherit (python) sitePackages;

  env = buildEnv {
    name = "${python.name}-environment";
    paths = pythonDepends ++ pythonFun (packages.extend extend);
  };
in

stdenv.mkDerivation {
  name = "${python.name}-user-environment";
  inherit pipFlags;
  buildInputs = [ env ] ++ buildInputs;

  shellHook = ''
    export PATH="$PWD/venv/bin:$PWD/venv/nix-profile/bin''${PATH:+:}$PATH"
    if ! test -e venv/nix-profile; then
      ${virtualenv}/bin/virtualenv venv --no-download
      if [ -n "$pipFlags" ]; then
        pip install $pipFlags -I --no-deps --disable-pip-version-check
      fi
      ${installHook}
    fi
    if test ${env} != "$(readlink venv/nix-profile)"; then
      rm venv/nix-profile 2> /dev/null || true
      echo ${env}/${sitePackages} > venv/${sitePackages}/${env.name}.pth
      nix-store -r ${env} --indirect --add-root $PWD/venv/nix-profile > /dev/null
    fi

    ${shellHook}
  '';
}
