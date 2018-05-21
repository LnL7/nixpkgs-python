{ stdenv, python, virtualenv, pythonPlatform, pythonScope, virtualenvHook, mkPythonEnv }:

{ src ? null
, withPackages ? p: []
, pythonTools ? [], pythonDepends ? []
, systemDepends ? []
, nativeBuildInputs ? []
, buildInputs ? []
, pipInstallFlags ? [ src ]
, installHook ? "", shellHook ? ""
, ...
}@attrs:

let
  env = mkPythonEnv {
    inherit pythonTools pythonDepends;
    withPackages = p: withPackages pythonScope;
  };
in

stdenv.mkDerivation (builtins.removeAttrs attrs ["withPackages"] // {
  name = "${pythonPlatform.python}-virtualenv-with-packages";
  inherit env pipInstallFlags;
  nativeBuildInputs = [ virtualenv virtualenvHook ] ++ nativeBuildInputs;
  buildInputs = [ env ] ++ systemDepends ++ buildInputs;

  SOURCE_DATE_EPOCH = "315532800";

  buildPhase = ''
    virtualenvPrefix=''${virtualenvPrefix:-$PWD/venv}

    virtualenvBuildPhase
    virtualenvInstallPhase

    echo ${env}/${pythonPlatform.sitePackages} > $virtualenvPrefix/${pythonPlatform.sitePackages}/nix-environment.pth
    ln -sfn ${env} $virtualenvPrefix/nix-profile
  '';

  installPhase = ''
    mv $virtualenvPrefix $out

    deactivate
    virtualenvPrefix=$out
    virtualenvBuildPhase
    source $out/bin/activate
  '';

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
})
