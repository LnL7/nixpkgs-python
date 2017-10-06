{ stdenv, buildEnv, fetchpypi, buildWheel, python, pip }:

{ src ? null
, pname ? src.pname
, version ? src.version
, sha256 ? src.sha256
, type ? ""
, name ? ""
, meta ? {}
, pythonDepends ? []
, systemDepends ? []
, buildInputs ? [], propagatedBuildInputs ? []
, nativeBuildInputs ? [], propagatedNativeBuildInputs ? []
, ...
} @ args:

let
  inherit (stdenv.lib) optional optionalAttrs optionalString;
  inherit (python) pythonVersion sitePackages;

  platforms = stdenv.lib.platforms.all;

  env = buildEnv {
    name = "${python.name}-environment";
    paths = pythonDepends;
  };

  wheel = buildWheel (args // {
    inherit pname version sha256;
    buildDepends = systemDepends;

    meta = { inherit platforms; } // meta;
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
  inherit env python wheel;

  src = wheel;
  wheelhouse = "${wheel}/${wheel.wheelhouse}";

  buildInputs = systemDepends;

  installPhase = ''
    mkdir -p $out/${sitePackages}
    ${pip}/bin/pip install $wheelhouse/*.whl --prefix $out --ignore-installed --no-cache-dir --no-deps --no-index

    rm -r $out/${sitePackages}/tests || true
  '';

  postFixup = ''
    for f in $out/bin/*; do
      substituteInPlace "$f" --replace '${python.interpreter}' '/usr/bin/env python${pythonVersion}'
    done
  '';

  passthru.src = wheel.src;

  meta = { inherit platforms; } // meta;
}
// optionalAttrs (buildInputs != [])                 { inherit buildInputs; }
// optionalAttrs (propagatedBuildInputs != [])       { inherit propagatedBuildInputs; }
// optionalAttrs (nativeBuildInputs != [])           { inherit nativeBuildInputs; }
// optionalAttrs (propagatedNativeBuildInputs != []) { inherit propagatedNativeBuildInputs; }
)
