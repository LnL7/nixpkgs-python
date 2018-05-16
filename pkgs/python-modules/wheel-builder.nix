{ pkgs, stdenv, unzip, python, pip, pythonPlatform, pythonScope, pipHook, mkPythonInfo }:

let
  inherit (stdenv.lib) optionalAttrs;
  isZip = src: builtins.any (stdenv.lib.hasSuffix ".zip") (src.urls or [src]);
in

{ pname, version, src
, name ? "wheel-${pythonPlatform.abi}-${pname}-${version}"
, meta ? {}
, info ? mkPythonInfo { inherit pname version src; }
, pipFlags ? [], pipWheelFlags ? [ "--wheel-dir" "./dist" ]
, buildDepends ? [], systemDepends ? [], pythonDepends ? []
, unpackPhase ? "", preUnpack ? "", postUnpack ? ""
, patches ? [], patchPhase ? "", prePatch ? "", postPatch ? ""
, configurePhase ? "", preConfigure ? "", postConfigure ? ""
, buildPhase ? "", preBuild ? "", postBuild ? ""
, distPhase ? "", preDist ? "", postDist ? ""
, hardeningDisable ? []
, ... }@attrs:

stdenv.mkDerivation ({
  inherit name src buildDepends systemDepends pythonDepends;
  inherit pipFlags pipWheelFlags;

  nativeBuildInputs = [ pipHook ] ++ stdenv.lib.optional (isZip src) unzip;
  buildInputs = [ python pip ];
  propagatedBuildInputs = systemDepends ++ pythonDepends;

  SOURCE_DATE_EPOCH = "315532800";

  buildPhase = ''
    runHook preBuild

    pipWheelPhase

    runHook postBuild
  '';

  installPhase = ":";

  doDist = true;

  distPhase = ''
    runHook preDist

    mkdir -p $out
    cp -r dist $out

    runHook postDist
  '';

  passthru = { inherit info pythonScope; };

  meta = with stdenv.lib; {
    platforms = platforms.all;
  } // meta;
}
// optionalAttrs (unpackPhase != "")      { inherit unpackPhase; }
// optionalAttrs (preUnpack != "")        { inherit preUnpack; }
// optionalAttrs (postUnpack != "")       { inherit postUnpack; }
// optionalAttrs (patches != [])          { inherit patches; }
// optionalAttrs (patchPhase != "")       { inherit patchPhase; }
// optionalAttrs (prePatch != "")         { inherit prePatch; }
// optionalAttrs (postPatch != "")        { inherit postPatch; }
// optionalAttrs (configurePhase != "")   { inherit configurePhase; }
// optionalAttrs (preConfigure != "")     { inherit preConfigure; }
// optionalAttrs (postConfigure != "")    { inherit postConfigure; }
// optionalAttrs (buildPhase != "")       { inherit buildPhase; }
// optionalAttrs (preBuild != "")         { inherit preBuild; }
// optionalAttrs (postBuild != "")        { inherit postBuild; }
// optionalAttrs (distPhase != "")        { inherit distPhase; }
// optionalAttrs (preDist != "")          { inherit preDist; }
// optionalAttrs (postDist != "")         { inherit postDist; }
// optionalAttrs (hardeningDisable != []) { inherit hardeningDisable; }
)
