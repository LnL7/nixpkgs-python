declare -ra virtualenvFlags=(--no-download)


virtualenvBuildPhase() {
    runHook preVirtualenvBuild

    local -a flagsArray=(
      $virtualenvFlags ${virtualenvFlagsArray+"${virtualenvFlagsArray[@]}"}
    )

    virtualenvPrefix=${virtualenvPrefix:-$prefix}

    virtualenv "$virtualenvPrefix" ${virtualenvFlags+"${virtualenvFlags[@]}"}
    substituteInPlace "$virtualenvPrefix/bin/activate" \
        --replace '$VIRTUAL_ENV/bin' '$VIRTUAL_ENV/bin:$VIRTUAL_ENV/nix-profile/bin'

    runHook postVirtualenvBuild
}


virtualenvInstallPhase() {
    runHook preVirtualenvInstall

    source venv/bin/activate
    dontPipPrefix=1 pipInstallPhase

    runHook postVirtualenvInstall
}
