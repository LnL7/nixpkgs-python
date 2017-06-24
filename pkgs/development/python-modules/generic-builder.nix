{ stdenv, buildEnv, fetchpypi, buildWheel, python, pip }:

{ pname
, version
, sha256
, type ? ""
, name ? ""
, pythonDepends ? []
, systemDepends ? []
, buildInputs ? [], propagatedBuildInputs ? []
, nativeBuildInputs ? [], propagatedNativeBuildInputs ? []
, hardeningDisable ? []
, CFLAGS ? "", NIX_CFLAGS_COMPILE ? ""
} @ args:

let

  inherit (stdenv.lib) optional optionalAttrs optionalString;

  inherit (python) sitePackages;
  inherit (src) pipWheels;

  env = buildEnv {
    name = "${python.name}-environment";
    paths = pythonDepends;
  };

  src = buildWheel ({
    inherit pname version sha256;
    buildDepends = systemDepends;
    inherit buildInputs propagatedBuildInputs;
    inherit nativeBuildInputs propagatedNativeBuildInputs;
  }
  // optionalAttrs (type != "")               { src = fetchpypi { inherit pname version sha256 type; }; }
  // optionalAttrs (name != "")               { src = fetchpypi { inherit pname version sha256 name; }; }
  // optionalAttrs (pythonDepends != [])      { pythonEnv = env; }
  // optionalAttrs (hardeningDisable != [])   { inherit hardeningDisable; }
  // optionalAttrs (CFLAGS != "")             { inherit CFLAGS; }
  // optionalAttrs (NIX_CFLAGS_COMPILE != "") { inherit NIX_CFLAGS_COMPILE; }
  );

in

stdenv.mkDerivation ({
  name = "${python.name}-${pname}-${version}";
  inherit src env python;

  installPhase = ''
    mkdir -p $out/${sitePackages}
    ${pip}/bin/pip install ${pipWheels}/* -t $out/${sitePackages} --no-cache-dir --no-deps --no-index

    rm -r $out/${sitePackages}/tests || true
  '';
}
// optionalAttrs (buildInputs != [])                 { inherit buildInputs; }
// optionalAttrs (propagatedBuildInputs != [])       { inherit propagatedBuildInputs; }
// optionalAttrs (nativeBuildInputs != [])           { inherit nativeBuildInputs; }
// optionalAttrs (propagatedNativeBuildInputs != []) { inherit propagatedNativeBuildInputs; }
)
