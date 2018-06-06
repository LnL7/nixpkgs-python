{ pkgs, stdenv, coreutils, python, pip, pythonPlatform, pythonScope, pipHook, mkShellEnv, mkPythonWheel }:

let
  inherit (stdenv.lib) optionalAttrs;
  checkPython = stdenv.lib.any (x: stdenv.lib.matchAttrs x pythonPlatform);

  mkDerivation =
    { pname, version, versionSuffix ? "", src ? null
    , name ? "python${pythonPlatform.version}-${pname}-${version}${versionSuffix}"
    , meta ? {}
    , passthru ? {}
    , info ? wheel.info
    , venv ? mkShellEnv attrs
    , wheel ? mkPythonWheel attrs
    , systemDepends ? [], pythonDepends ? []
    , pipFlags ? []
    , dontPipCheck ? false, pipCheckFlags ? []
    , dontDetectConflicts ? false
    , dontRemoveTests ? false
    , pipInstallFlags ? [ "${pname}==${version}" "--find-links" "./dist" ]
    , nativeBuildInputs ? [], propagatedNativeBuildInputs ? []
    , buildInputs ? [], propagatedBuildInputs ? []
    , pipCheckPhase ? "", prePipCheck ? "", postPipCheck ? ""
    , pipInstallPhase ? "", prePipInstall ? "", postPipInstall ? ""
    , outputs ? [ "out" ]
    , doCheck ? false
    , doInstallCheck ? false
    , dontPatchShebangs ? false
    , checkPhase ? "", preCheck ? "", postCheck ? ""
    , installPhase ? "", preInstall ? "", postInstall ? ""
    , installCheckPhase ? "", preInstallCheck ? "", postInstallCheck ? ""
    , fixupPhase ? "", preFixup ? "", postFixup ? ""
    , ... }@attrs:

    stdenv.mkDerivation ({
      inherit name pname version versionSuffix;
      inherit pipFlags pipCheckFlags pipInstallFlags;
      inherit systemDepends pythonDepends;
      src = wheel;

      nativeBuildInputs = [ pipHook ] ++ nativeBuildInputs;
      buildInputs = [ python pip ] ++ systemDepends ++ pythonDepends ++ buildInputs;
      inherit propagatedBuildInputs;

      installPhase = ''
        runHook preInstall

        pipInstallPhase

        ${pythonPlatform.python} -OO -m compileall -qf $out/${pythonPlatform.sitePackages} || true

        for dep in $pythonDepends; do
            for f in $(find $dep/${pythonPlatform.sitePackages} -type f -o -type l); do
                l=''${f/$dep/$out}
                f=$(readlink -f "$f")
                if [ -s "$l" ]; then
                    continue
                fi
                if [ -L "$l" ]; then
                    l=$(readlink -f "$f")
                    if [ "$f" = "$l" ]; then
                        continue
                    fi
                fi
                mkdir -p "$(dirname "$l")"
                ln -s "$f" "$l"
            done
        done

        if [ -z "''${dontDetectConflicts:-}" ]; then
            ${pythonPlatform.python} ${./pip/detect_conflicts.py} $out/${pythonPlatform.sitePackages}/*.dist-info
        fi

        rm -rf $out/bin/__pycache__

        if [ -z "''${dontRemoveTests:-}" ]; then
            rm -rf $out/${pythonPlatform.sitePackages}/test $out/${pythonPlatform.sitePackages}/tests
        fi

        runHook postInstall
      '';

      postFixup = ''
        for f in $out/bin/*; do
            substituteInPlace $f \
                --replace "import sys" "import sys; sys.path.append('$out/${pythonPlatform.sitePackages}')"
        done
      '' + postFixup;

      passthru = {
        inherit info venv wheel src pythonScope;
        overrideAttrs = f: mkDerivation (attrs // (f attrs));
      } // passthru;

      meta = with stdenv.lib; {
        platforms = platforms.all;
        broken = !checkPython (meta.python or [{}]);
      } // meta;
    }
    // optionalAttrs (dontPipCheck)            { inherit dontPipCheck; }
    // optionalAttrs (dontDetectConflicts)     { inherit dontDetectConflicts; }
    // optionalAttrs (dontRemoveTests)         { inherit dontRemoveTests; }
    // optionalAttrs (pipCheckPhase != "")     { inherit pipCheckPhase; }
    // optionalAttrs (prePipCheck != "")       { inherit prePipCheck; }
    // optionalAttrs (postPipCheck != "")      { inherit postPipCheck; }
    // optionalAttrs (pipInstallPhase != "")   { inherit pipInstallPhase; }
    // optionalAttrs (prePipInstall != "")     { inherit prePipInstall; }
    // optionalAttrs (postPipInstall != "")    { inherit postPipInstall; }
    // optionalAttrs (outputs != ["out"])      { inherit outputs; }
    // optionalAttrs (doCheck)                 { inherit doCheck; }
    // optionalAttrs (doInstallCheck)          { inherit doInstallCheck; }
    // optionalAttrs (dontPatchShebangs)       { inherit dontPatchShebangs; }
    // optionalAttrs (checkPhase != "")        { inherit checkPhase; }
    // optionalAttrs (preCheck != "")          { inherit preCheck; }
    // optionalAttrs (postCheck != "")         { inherit postCheck; }
    // optionalAttrs (installPhase != "")      { inherit installPhase; }
    // optionalAttrs (preInstall != "")        { inherit preInstall; }
    // optionalAttrs (postInstall != "")       { inherit postInstall; }
    // optionalAttrs (installCheckPhase != "") { inherit installCheckPhase; }
    // optionalAttrs (preInstallCheck != "")   { inherit preInstallCheck; }
    // optionalAttrs (postInstallCheck != "")  { inherit postInstallCheck; }
    // optionalAttrs (fixupPhase != "")        { inherit fixupPhase; }
    // optionalAttrs (preFixup != "")          { inherit preFixup; }
    #  optionalAttrs (postFixup != "")         { }
    );
in
  mkDerivation
