# Determinism: The interpreter is patched to write null timestamps when compiling python files.
# This way python doesn't try to update them when we freeze timestamps in nix store.
export DETERMINISTIC_BUILD=1;
# Determinism: We fix the hashes of str, bytes and datetime objects.
export PYTHONHASHSEED=0;
# Determinism. Whenever Python is included, it should not check user site-packages.
# This option is only relevant when the sandbox is disabled.
export PYTHONNOUSERSITE=1;


declare -ga pipFlagsArray=(--isolated --no-cache-dir --disable-pip-version-check)
declare -ga pipCheckFlagsArray=()
declare -ga pipInstallFlagsArray=(--no-deps --no-index --ignore-installed)
declare -ga pipWheelFlagsArray=(--no-deps --no-index)


pipCheckPhase() {
    runHook prePipCheck

    : ${pipFlags=}
    : ${pipCheckFlags=}

    local -a flagsArray=(
      $pipFlags ${pipFlagsArray+"${pipFlagsArray[@]}"}
      $pipCheckFlags ${pipCheckFlagsArray+"${pipCheckFlagsArray[@]}"}
    )

    pipPrefix=${pipPrefix:-$prefix}

    echoCmd '@pip@ check flags' ${flagsArray+"${flagsArray[@]}"}
    if [ -e "${pipPrefix:-}/@sitePackages@" ]; then
        PYTHONPATH=${pipPrefix:-}/@sitePackages@ @pip@ check ${flagsArray+"${flagsArray[@]}"}
    else
        @pip@ check ${flagsArray+"${flagsArray[@]}"}
    fi

    runHook postPipCheck
}

if [ -z "${dontPipCheck:-}" ]; then
    preFixupPhases+=pipCheckPhase
fi


pipInstallPhase() {
    runHook prePipInstall

    : ${pipFlags=}
    : ${pipInstallFlags=}

    local -a flagsArray=(
      $pipFlags ${pipFlagsArray+"${pipFlagsArray[@]}"}
      $pipInstallFlags ${pipInstallFlagsArray+"${pipInstallFlagsArray[@]}"}
    )

    pipPrefix=${pipPrefix:-$prefix}

    if [ -z "${dontPipPrefix:-}" ]; then
        flagsArray+=(--prefix "$pipPrefix")
    fi

    echoCmd '@pip@ install flags' ${flagsArray+"${flagsArray[@]}"}
    @pip@ install ${flagsArray+"${flagsArray[@]}"}

    runHook postPipInstall
}


pipWheelPhase() {
    runHook prePipWheel

    : ${pipFlags=}
    : ${pipWheelFlags=}

    local -a flagsArray=(
      $pipFlags ${pipFlagsArray+"${pipFlagsArray[@]}"}
      $pipWheelFlags ${pipWheelFlagsArray+"${pipWheelFlagsArray[@]}"}
    )

    echoCmd '@pip@ wheel flags' "${flagsArray[@]}"
    @pip@ wheel . "${flagsArray[@]}"

    runHook postPipWheel
}
