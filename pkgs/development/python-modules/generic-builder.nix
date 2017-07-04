{ stdenv, buildEnv, fetchpypi, buildWheel, python, pip }:

{ src ? null
, pname ? src.pname
, version ? src.version
, sha256 ? src.sha256
, type ? ""
, name ? ""
, pythonDepends ? []
, systemDepends ? []
, buildInputs ? [], propagatedBuildInputs ? []
, nativeBuildInputs ? [], propagatedNativeBuildInputs ? []
, ...
} @ args:

let

  inherit (stdenv.lib) optional optionalAttrs optionalString;

  inherit (python) sitePackages;
  inherit (wheel) wheelhouse;

  env = buildEnv {
    name = "${python.name}-environment";
    paths = pythonDepends;
  };

  wheel = buildWheel (args // {
    inherit pname version sha256;
    buildDepends = systemDepends;
  }
  // optionalAttrs (src == null)         { src = fetchpypi { inherit pname version sha256; }; }
  // optionalAttrs (type != "")          { src = fetchpypi { inherit pname version sha256 type; }; }
  // optionalAttrs (name != "")          { src = fetchpypi { inherit pname version sha256 name; }; }
  // optionalAttrs (pythonDepends != []) { pythonEnv = env; }
  );

in

stdenv.mkDerivation ({
  name = "${python.name}-${pname}-${version}";
  inherit pname version sha256;
  inherit env python wheel wheelhouse;

  passthru.src = wheel.src;

  src = wheel;

  installPhase = ''
    mkdir -p $out/${sitePackages}
    ${pip}/bin/pip install ${wheelhouse}/* --prefix $out --ignore-installed --no-cache-dir --no-deps --no-index

    rm -r $out/${sitePackages}/tests || true
  '';
}
// optionalAttrs (buildInputs != [])                 { inherit buildInputs; }
// optionalAttrs (propagatedBuildInputs != [])       { inherit propagatedBuildInputs; }
// optionalAttrs (nativeBuildInputs != [])           { inherit nativeBuildInputs; }
// optionalAttrs (propagatedNativeBuildInputs != []) { inherit propagatedNativeBuildInputs; }
)
