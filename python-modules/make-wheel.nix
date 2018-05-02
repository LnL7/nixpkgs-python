{ pkgs, stdenv, unzip, python, pip, pythonPlatform }:

let
  isZip = src: builtins.any (stdenv.lib.hasSuffix ".zip") (src.urls or [src]);
in

{ pname, version, src
, name ? "wheel-${pythonPlatform.abi}-${pname}-${version}"
, pipFlags ? [ "--isolated" "--no-cache-dir" "--disable-pip-version-check" ]
, systemDepends ? [], pythonDepends ? []
, buildInputs ? [], nativeBuildInputs ? []
, propagatedBuildInputs ? []
, ...
}@attr:

stdenv.mkDerivation (attr // {
  inherit name pipFlags;

  nativeBuildInputs = stdenv.lib.optional (isZip src) unzip
    ++ nativeBuildInputs;
  buildInputs = [ python pip ] ++ buildInputs;
  propagatedBuildInputs = systemDepends ++ pythonDepends ++ propagatedBuildInputs;

  SOURCE_DATE_EPOCH = "315532800";

  buildPhase = ''
    runHook preBuild

    ${pythonPlatform.pip} wheel . $pipFlags --no-deps --no-index --wheel-dir ./dist

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r dist $out

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    meta.platforms = platforms.all;
  };
})
