{ pkgs, stdenv, coreutils, python, pip, pythonPlatform, pythonScope, pipHook, mkPythonWheel }:

let
  inherit (stdenv.lib) optionalAttrs;
  checkPython = stdenv.lib.any (x: stdenv.lib.matchAttrs x pythonPlatform);
in

{ pname, version, src ? null
, name ? "python${pythonPlatform.version}-${pname}-${version}"
, meta ? {}
, info ? wheel.info
, wheel ? mkPythonWheel attrs
, systemDepends ? [], pythonDepends ? []
, pipFlags ? []
, dontPipCheck ? false, pipCheckFlags ? []
, pipInstallFlags ? [ "${pname}==${version}" "--find-links" "./dist" ]
, nativeBuildInputs ? [], propagatedNativeBuildInputs ? []
, buildInputs ? [], propagatedBuildInputs ? []
, pipCheckPhase ? "", prePipCheck ? "", postPipCheck ? ""
, pipInstallPhase ? "", prePipInstall ? "", postPipInstall ? ""
, doCheck ? false
, installPhase ? "", preInstall ? "", postInstall ? ""
, checkPhase ? "", preCheck ? "", postCheck ? ""
, fixupPhase ? "", preFixup ? "", postFixup ? ""
, ... }@attrs:

stdenv.mkDerivation ({
  inherit name pname version wheel;
  inherit pipFlags pipCheckFlags pipInstallFlags;
  inherit systemDepends pythonDepends;
  src = wheel;

  nativeBuildInputs = [ pipHook ] ++ nativeBuildInputs;
  buildInputs = [ pip ] ++ buildInputs;
  propagatedBuildInputs = [ python ] ++ systemDepends ++ propagatedBuildInputs;

  installPhase = ''
    runHook preInstall

    pipInstallPhase

    for dep in $pythonDepends; do
        for f in $dep/${pythonPlatform.sitePackages}/*; do
            name=''${f##*/}
            l=$out/${pythonPlatform.sitePackages}/$name
            if [ "$name" = __pycache__ ]; then
                continue
            fi
            if [ "$(readlink -f $f)" = "$(readlink -f $l)" ]; then
                continue
            fi
            if ! ln -s "$f" "$l"; then
                echo
                echo "error: conflicting dependency '$name' in"
                echo "  $(readlink -f $f)"
                echo "  $(readlink -f $l)"
                echo
                false
            fi
        done
    done

    rm -rf $out/bin/__pycache__

    runHook postInstall
  '';

  postFixup = ''
    for f in $out/bin/*; do
        substituteInPlace $f \
            --replace "import sys" "import sys; sys.path.append('$out/${pythonPlatform.sitePackages}')"
    done
  '' + postFixup;

  passthru = { inherit info src pythonScope; };

  meta = with stdenv.lib; {
    platforms = platforms.all;
    broken = !checkPython (meta.python or [{}]);
  } // meta;
}
// optionalAttrs (dontPipCheck)          { inherit dontPipCheck; }
// optionalAttrs (pipCheckPhase != "")   { inherit pipCheckPhase; }
// optionalAttrs (prePipCheck != "")     { inherit prePipCheck; }
// optionalAttrs (postPipCheck != "")    { inherit postPipCheck; }
// optionalAttrs (pipInstallPhase != "") { inherit pipInstallPhase; }
// optionalAttrs (prePipInstall != "")   { inherit prePipInstall; }
// optionalAttrs (postPipInstall != "")  { inherit postPipInstall; }
// optionalAttrs (doCheck)               { inherit doCheck; }
// optionalAttrs (checkPhase != "")      { inherit checkPhase; }
// optionalAttrs (preCheck != "")        { inherit preCheck; }
// optionalAttrs (postCheck != "")       { inherit postCheck; }
// optionalAttrs (installPhase != "")    { inherit installPhase; }
// optionalAttrs (preInstall != "")      { inherit preInstall; }
// optionalAttrs (postInstall != "")     { inherit postInstall; }
// optionalAttrs (fixupPhase != "")      { inherit fixupPhase; }
// optionalAttrs (preFixup != "")        { inherit preFixup; }
#  optionalAttrs (postFixup != "")       { }
)
