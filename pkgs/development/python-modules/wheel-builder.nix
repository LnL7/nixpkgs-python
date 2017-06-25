{ stdenv, python, pip }:

{ pname
, version
, src
, pythonEnv ? null
, buildDepends ? []
, buildInputs ? [], propagatedBuildInputs ? []
, nativeBuildInputs ? [], propagatedNativeBuildInputs ? []
, ...
}@args:

let

  inherit (stdenv.lib) optionalAttrs optionalString;
  inherit (python) sitePackages;

  wheelhouse = "share/pip/wheelhouse";

in

stdenv.mkDerivation (args // {
  name = "${python.name}-whl-${pname}-${version}";
  inherit src;
  inherit wheelhouse python;

  PYTHONPATH = optionalString (pythonEnv != null) "${pythonEnv}/${sitePackages}";
  SOURCE_DATE_EPOCH = "315542800";

  buildInputs = buildDepends;

  unpackPhase = ":";

  buildPhase = ''
    ${pip}/bin/pip wheel ${src} -w . --no-cache-dir --no-deps --no-index
  '';

  installPhase = ''
    mkdir -p $out/${wheelhouse}
    cp *.whl $out/${wheelhouse}
  '';
}
// optionalAttrs (buildInputs != [])                 { inherit buildInputs; }
// optionalAttrs (propagatedBuildInputs != [])       { inherit propagatedBuildInputs; }
// optionalAttrs (nativeBuildInputs != [])           { inherit nativeBuildInputs; }
// optionalAttrs (propagatedNativeBuildInputs != []) { inherit propagatedNativeBuildInputs; }
)
