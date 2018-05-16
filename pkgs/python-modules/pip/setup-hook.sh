# Determinism: The interpreter is patched to write null timestamps when compiling python files.
# This way python doesn't try to update them when we freeze timestamps in nix store.
export DETERMINISTIC_BUILD=1;
# Determinism: We fix the hashes of str, bytes and datetime objects.
export PYTHONHASHSEED=0;
# Determinism. Whenever Python is included, it should not check user site-packages.
# This option is only relevant when the sandbox is disabled.
export PYTHONNOUSERSITE=1;


declare -a pipFlagsArray=(--isolated --no-cache-dir --disable-pip-version-check)
declare -a pipCheckFlagsArray


pipCheckPhase() {
    runHook prePipCheck

    : ${pipFlags=}
    : ${pipCheckFlags=}

    local -a flagsArray=(
      $pipFlags ${pipFlagsArray+"${pipFlagsArray[@]}"}
      $pipCheckFlags ${pipCheckFlagsArray+"${pipCheckFlagsArray[@]}"}
    )

    PYTHONPATH=$out/@sitePackages@ @pip@ check ${flagsArray+"${flagsArray[@]}"}

    runHook postPipCheck
}

if [ -z "${dontPipCheck:-}" ]; then
    preFixupPhases+=pipCheckPhase
fi
