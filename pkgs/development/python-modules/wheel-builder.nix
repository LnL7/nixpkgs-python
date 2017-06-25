{ stdenv, fetchpypi, python, pip }:

{ pname
, version
, sha256 ? ""
, src ? fetchpypi { inherit pname version sha256; }
, pythonEnv ? null
, buildDepends ? []
, buildInputs ? [], propagatedBuildInputs ? []
, nativeBuildInputs ? [], propagatedNativeBuildInputs ? []
, NIX_CFLAGS_COMPILE ? ""
, ...
}@args:

let

  inherit (stdenv.lib) optionalAttrs optionalString;
  inherit (python) sitePackages;

  pipWheels = "share/pip/wheelhouse";

in

stdenv.mkDerivation ({
  name = "${python.name}-whl-${pname}-${version}";
  inherit src;
  inherit pipWheels python;

  SOURCE_DATE_EPOCH = "315542800";

  PYTHONPATH = optionalString (pythonEnv != null) "${pythonEnv}/${sitePackages}";

  nativeBuildInputs = buildDepends;

  unpackPhase = ":";

  buildPhase = ''
    mkdir tmp
    ${pip}/bin/pip wheel ${src} -w . --no-cache-dir --no-deps --no-index
  '';

  installPhase = ''
    mkdir -p $out/${pipWheels}
    cp *.whl $out/${pipWheels}
  '';
}
// optionalAttrs (buildInputs != [])                 { inherit buildInputs; }
// optionalAttrs (propagatedBuildInputs != [])       { inherit propagatedBuildInputs; }
// optionalAttrs (nativeBuildInputs != [])           { inherit nativeBuildInputs; }
// optionalAttrs (propagatedNativeBuildInputs != []) { inherit propagatedNativeBuildInputs; }
// optionalAttrs (NIX_CFLAGS_COMPILE != "")          { inherit NIX_CFLAGS_COMPILE; }
)
