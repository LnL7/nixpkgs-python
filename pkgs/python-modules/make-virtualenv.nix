{ stdenv, python, virtualenv, pythonPlatform, pythonScope, virtualenvHook, mkPythonEnv }:

{ src ? null
, name ? "${pythonPlatform.python}-virtualenv-with-packages"
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
  inherit name env pipInstallFlags;
  nativeBuildInputs = [ virtualenv virtualenvHook ] ++ nativeBuildInputs;
  buildInputs = [ env ] ++ systemDepends ++ buildInputs;

  SOURCE_DATE_EPOCH = "315532800";

  buildPhase = ''
    runHook preBuild

    virtualenvPrefix=''${virtualenvPrefix:-$PWD/venv}

    virtualenvBuildPhase
    virtualenvInstallPhase

    echo ${env}/${pythonPlatform.sitePackages} > $virtualenvPrefix/${pythonPlatform.sitePackages}/nix-environment.pth
    ln -sfn ${env} $virtualenvPrefix/nix-profile

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    deactivate
    mv $virtualenvPrefix $out

    virtualenvPrefix=$out
    virtualenvBuildPhase
    source $out/bin/activate

    runHook postInstall
  '';

  shellHook = ''
    prefix=$PWD/venv
    profile=$prefix/nix-profile

    PATH=$prefix/bin:$profile/bin:$PATH

    if ! test -e $profile; then
        virtualenvBuildPhase
        virtualenvInstallPhase
        ${installHook}
        deactivate
    fi

    if test ${env} != "$(readlink $profile)"; then
        rm $profile 2> /dev/null || true
        echo ${env}/${pythonPlatform.sitePackages} > $prefix/${pythonPlatform.sitePackages}/nix-environment.pth
        nix-store -r ${env} --indirect --add-root $profile > /dev/null
    fi

    ${shellHook}
  '';
})
