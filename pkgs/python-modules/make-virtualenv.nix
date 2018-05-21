{ stdenv, mkShell, python, virtualenv, pythonPlatform, pythonScope, pipHook, mkPythonEnv }:

{ withPackages
, pythonTools ? [], pythonDepends ? []
, systemDepends ? []
, buildInputs ? []
, pipFlags ? [], pipInstallFlags? []
, installHook ? ""
, shellHook ? ""
}:

let
  env = mkPythonEnv {
    inherit pythonTools pythonDepends;
    withPackages = p: withPackages pythonScope;
  };
in

mkShell {
  name = "${pythonPlatform.python}-shell-environment";
  inherit env pipFlags;
  nativeBuildInputs = [ pipHook ];
  buildInputs = [ env ] ++ systemDepends ++ buildInputs;

  dontPipPrefix = true;

  shellHook = ''
    prefix=$PWD/venv
    profile=$prefix/nix-profile

    PATH=$prefix/bin:$profile/bin:$PATH

    if ! test -e $profile; then
        ${virtualenv}/bin/virtualenv $prefix --no-download
        substituteInPlace $prefix/bin/activate \
            --replace '$VIRTUAL_ENV/bin' '$VIRTUAL_ENV/bin:$VIRTUAL_ENV/nix-profile/bin'

        pipInstallPhase
        ${installHook}
    fi

    if test ${env} != "$(readlink $profile)"; then
        rm $profile 2> /dev/null || true
        echo ${env}/${pythonPlatform.sitePackages} > $prefix/${pythonPlatform.sitePackages}/nix-environment.pth
        nix-store -r ${env} --indirect --add-root $profile > /dev/null
    fi

    ${shellHook}
  '';
}
