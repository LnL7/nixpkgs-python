{ pkgs, stdenv, unzip, python, pip, pythonPlatform }:

let
  isZip = src: builtins.any (stdenv.lib.hasSuffix ".zip") (src.urls or [src]);
in

{ pname, version, src
, type ? "dist"
, name ? "${pname}-${version}.${type}-info"
, buildInputs ? [], nativeBuildInputs ? []
, ...
}@attr:

stdenv.mkDerivation (attr // {
  inherit name;
  nix_setup = ./nix_setup.py;

  nativeBuildInputs = stdenv.lib.optional (isZip src) unzip
    ++ nativeBuildInputs;
  buildInputs = [ python pip ] ++ buildInputs;

  SOURCE_DATE_EPOCH = "315532800";

  postPatch = ''
    if [ -f setup.cfg ]; then
        sed -e '/license-file/d' -e '/license_file/d' -i setup.cfg
    fi
  '';

  buildPhase = ''
    runHook preBuild

    cp $nix_setup nix_setup.py
    ${pythonPlatform.python} nix_setup.py ${type}_info --egg-base .

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r ${pname}.${type}-info $out

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    meta.platforms = platforms.all;
  };
})
