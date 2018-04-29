{ pkgs, config, pythonPlatform, python, stdenv, runCommand, fetchurl }:

let
  isZip = stdenv.lib.any (stdenv.lib.hasSuffix ".zip");

  defaultPipFlags = [ "--isolated" "--no-cache-dir" "--disable-pip-version-check" ];

  wheelSrc = fetchurl {
    url = https://pypi.python.org/packages/py2.py3/w/wheel/wheel-0.29.0-py2.py3-none-any.whl;
    sha256 = "1g8f0p8kp1k6kaa3rpbq396401qa84rlsivm5xjlx005k7y3707a";
  };
in

rec {
  inherit pythonPlatform python;

  pip = runCommand "python${pythonPlatform.version}-pip"
    { nativeBuildInputs = [ pkgs.unzip ]; buildInputs = [ python ]; }
    ''
      mkdir $out
      ln -s $out .local
      export HOME=$(pwd)
      ${pythonPlatform.python} -m ensurepip --user

      unzip -d $out/${pythonPlatform.sitePackages} ${wheelSrc}

      for f in $out/bin/*; do
          substituteInPlace $f \
              --replace "import sys" "import sys; sys.path.append('$out/${pythonPlatform.sitePackages}')"
      done
    '';

  mkPythonWheel =
    { pname, version, src
    , name ? "wheel-${pythonPlatform.abi}-${pname}-${version}"
    , setupFlags ? [], systemDepends ? []
    , buildInputs ? [], nativeBuildInputs ? []
    , propagatedBuildInputs ? []
    , ...
    }@attr:
    stdenv.mkDerivation (attr // {
      inherit name src setupFlags;

      nativeBuildInputs = stdenv.lib.optional (isZip src.urls) pkgs.unzip
        ++ nativeBuildInputs;
      buildInputs = [ python pip ] ++ buildInputs;
      propagatedBuildInputs = systemDepends ++ propagatedBuildInputs;

      buildPhase = ''
        ${pythonPlatform.python} ./setup.py $setupFlags bdist_wheel
      '';

      installPhase = ''
        mkdir -p $out
        cp -r dist $out
      '';
    });

  mkPythonPackage =
    { pname, version, src ? null
    , wheel ? mkPythonWheel { inherit pname version src setupFlags systemDepends; }
    , name ? "python${pythonPlatform.version}-${pname}-${version}"
    , pipFlags ? [ "--ignore-installed" ] ++ defaultPipFlags
    , setupFlags ? [], pythonDepends ? [], systemDepends ? []
    , buildInputs ? [], propagatedBuildInputs ? []
    , ... }@attr:
    stdenv.mkDerivation (attr // {
      inherit name wheel pipFlags;
      src = wheel;
      buildInputs = [ python pip ] ++ buildInputs;
      propagatedBuildInputs = pythonDepends ++ propagatedBuildInputs;

      installPhase = ''
        ${pythonPlatform.pip} install '${pname}==${version}' $pipFlags --no-deps --no-index --find-links ./dist --prefix $out

        for f in $out/bin/*; do
            substituteInPlace $f \
                --replace "import sys" "import sys; sys.path.append('$out/${pythonPlatform.sitePackages}')"
        done
      '';
    });
}
