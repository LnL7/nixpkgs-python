{ stdenv, mkShell, python, virtualenv, pythonPlatform, pythonScope, mkPythonEnv }:

{ withPackages
, pythonTools ? [], pythonDepends ? []
, systemDepends ? []
, buildInputs ? []
, installHook ? "", pipFlags ? ""
, shellHook ? ""
}:

let
  env = mkPythonEnv {
    inherit pythonTools pythonDepends;
    withPackages = p: withPackages pythonScope;
  };
in

mkShell {
  name = "${python.name}-shell-environment";
  inherit env pipFlags;
  buildInputs = [ env ] ++ systemDepends ++ buildInputs;

  shellHook = ''
    prefix=$PWD/venv
    profile=$prefix/nix-profile

    PATH=$prefix/bin:$profile/bin:$PATH

    if ! test -e $profile; then
        ${virtualenv}/bin/virtualenv $prefix --no-download
        substituteInPlace $prefix/bin/activate \
            --replace '$VIRTUAL_ENV/bin' '$VIRTUAL_ENV/bin:$VIRTUAL_ENV/nix-profile/bin'

        if [ -n "$pipFlags" ]; then
            pip install $pipFlags -I --no-deps --disable-pip-version-check
        fi
        ${installHook}
    fi

    if test ${env} != "$(readlink $profile)"; then
        rm $profile 2> /dev/null || true
        echo ${env}/${pythonPlatform.sitePackages} > $prefix/${pythonPlatform.sitePackages}/${env.name}.pth
        nix-store -r ${env} --indirect --add-root $profile > /dev/null
    fi

    ${shellHook}
  '';
}
