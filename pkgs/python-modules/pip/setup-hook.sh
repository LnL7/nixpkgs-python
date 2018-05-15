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

preFixupPhases+=pipCheckPhase
