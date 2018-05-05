{ pkgs, stdenv, unzip, python, pip, pythonPlatform, mkPythonInfo }:

let
  isZip = src: builtins.any (stdenv.lib.hasSuffix ".zip") (src.urls or [src]);
in

{ pname, version, src
, name ? "wheel-${pythonPlatform.abi}-${pname}-${version}"
, info ? mkPythonInfo { inherit pname version src; }
, pipFlags ? []
, systemDepends ? [], pythonDepends ? []
, buildInputs ? [], nativeBuildInputs ? []
, propagatedBuildInputs ? []
, ...
}@attr:

stdenv.mkDerivation (attr // {
  inherit name;
  pipFlags = [ "--isolated" "--no-cache-dir" "--no-deps" "--no-index" ] ++ pipFlags;

  nativeBuildInputs = stdenv.lib.optional (isZip src) unzip
    ++ nativeBuildInputs;
  buildInputs = [ python pip ] ++ buildInputs;
  propagatedBuildInputs = systemDepends ++ pythonDepends ++ propagatedBuildInputs;

  SOURCE_DATE_EPOCH = "315532800";

  buildPhase = ''
    runHook preBuild

    ${pythonPlatform.pip} wheel . $pipFlags --wheel-dir ./dist

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
    meta.platforms = platforms.all;
  };
})
