{ buildEnv, mkShell, python, virtualenv
, interpreter, packages, pythonPlatform
}:

{ withPackages
, extend ? (self: super: {})
, pythonDepends ? []
, buildInputs ? []
, installHook ? "", pipFlags ? ""
, shellHook ? ""
}:

let
  inherit (python) sitePackages;

  env = buildEnv {
    name = "${python.name}-environment";
    paths = pythonDepends ++ withPackages (packages.extend extend);
  };
in

mkShell {
  name = "${python.name}-shell-environment";
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
