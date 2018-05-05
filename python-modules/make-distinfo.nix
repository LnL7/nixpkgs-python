{ pkgs, stdenv, unzip, python, pip, pythonPlatform }:

let
  isZip = src: builtins.any (stdenv.lib.hasSuffix ".zip") (src.urls or [src]);
in

{ pname, version, src
, name ? "${pname}-${version}.dist-info"
, buildInputs ? [], nativeBuildInputs ? []
, ...
}@attr:

stdenv.mkDerivation (attr // {
  inherit name;

  nativeBuildInputs = stdenv.lib.optional (isZip src) unzip
    ++ nativeBuildInputs;
  buildInputs = [ python pip ] ++ buildInputs;

  SOURCE_DATE_EPOCH = "315532800";

  buildPhase = ''
    runHook preBuild

    ${pythonPlatform.python} ${./nix_setup.py} dist_info --egg-base .

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r ${pname}.dist-info $out

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    meta.platforms = platforms.all;
  };
})
