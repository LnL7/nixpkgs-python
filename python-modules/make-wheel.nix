{ pkgs, stdenv, unzip, python, pip, pythonPlatform, mkPythonInfo }:

let
  isZip = src: builtins.any (stdenv.lib.hasSuffix ".zip") (src.urls or [src]);
in

{ pname, version, src
, name ? "wheel-${pythonPlatform.abi}-${pname}-${version}"
, meta ? {}
, info ? mkPythonInfo { inherit pname version src; }
, pipFlags ? [], pipWheelFlags ? []
, systemDepends ? [], pythonDepends ? []
, buildInputs ? [], nativeBuildInputs ? []
, propagatedBuildInputs ? []
, ...
}@attr:

stdenv.mkDerivation (attr // {
  inherit name systemDepends pythonDepends;
  pipFlags = [ "--isolated" "--no-cache-dir" "--disable-pip-version-check" ] ++ pipFlags;
  pipWheelFlags = [ "--no-deps" "--no-index" ] ++ pipWheelFlags;

  nativeBuildInputs = stdenv.lib.optional (isZip src) unzip
    ++ nativeBuildInputs;
  buildInputs = [ python pip ] ++ buildInputs;
  propagatedBuildInputs = systemDepends ++ pythonDepends ++ propagatedBuildInputs;

  SOURCE_DATE_EPOCH = "315532800";

  buildPhase = ''
    runHook preBuild

    ${pythonPlatform.pip} wheel . $pipFlags $pipWheelFlags --wheel-dir ./dist

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r dist $out

    runHook postInstall
  '';

  passthru = { inherit info pip; };

  meta = with stdenv.lib; {
    platforms = platforms.all;
  } // meta;
})
