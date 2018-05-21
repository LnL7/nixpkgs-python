{ stdenv, mkShell, python, virtualenv, pythonPlatform, pythonScope, virtualenvHook, mkPythonEnv }:

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
  inherit env pipFlags pipInstallFlags;
  nativeBuildInputs = [ virtualenv virtualenvHook ];
  buildInputs = [ env ] ++ systemDepends ++ buildInputs;

  shellHook = ''
    prefix=$PWD/venv
    profile=$prefix/nix-profile

    if ! test -e $profile; then
        virtualenvBuildPhase
        virtualenvInstallPhase
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
