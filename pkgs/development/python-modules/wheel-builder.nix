{ stdenv, unzip, python, pip }:

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

  inherit (stdenv.lib) optional optionalAttrs optionalString;
  inherit (python) sitePackages;

  wheelhouse = "share/pip/wheelhouse";

in

stdenv.mkDerivation (args // {
  name = "${python.name}-whl-${pname}-${version}";
  inherit src;
  inherit wheelhouse python;

  PYTHONPATH = optionalString (pythonEnv != null) "${pythonEnv}/${sitePackages}";
  SOURCE_DATE_EPOCH = "315542800";

  buildInputs = optional (builtins.match ".*\.zip" "${src}" != null) [ unzip ];
  propagatedBuildInputs = buildDepends;

  buildPhase = ''
    ${pip}/bin/pip wheel . -w dist --no-cache-dir --no-deps --no-index
  '';

  installPhase = ''
    mkdir -p $out/${wheelhouse}
    cp dist/*.whl $out/${wheelhouse}
  '';
}
// optionalAttrs (buildInputs != [])                 { inherit buildInputs; }
// optionalAttrs (propagatedBuildInputs != [])       { inherit propagatedBuildInputs; }
// optionalAttrs (nativeBuildInputs != [])           { inherit nativeBuildInputs; }
// optionalAttrs (propagatedNativeBuildInputs != []) { inherit propagatedNativeBuildInputs; }
)
