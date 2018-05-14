{ pkgs, buildEnv, mkShell, python, virtualenv, pythonPlatform, pythonScope }:

{ withPackages
, buildInputs ? []
, installHook ? "", pipFlags ? ""
, shellHook ? ""
}:

let
  pythonDepends = withPackages pythonScope;

  env = buildEnv {
    name = "${python.name}-environment";
    paths = pythonDepends;
  };
in

mkShell {
  name = "${python.name}-shell-environment";
  inherit env pythonDepends pipFlags;

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
      echo ${env}/${pythonPlatform.sitePackages} > venv/${pythonPlatform.sitePackages}/${env.name}.pth
      nix-store -r ${env} --indirect --add-root $PWD/venv/nix-profile > /dev/null
    fi

    ${shellHook}
  '';
}