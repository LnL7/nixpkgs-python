{ pkgs, stdenv, buildEnv, mkShell, runCommand, fetchurl
, python, virtualenv, pythonPlatform, self

, overrides ? (self: super: {})
, interpreterConfig ? (self: super: {})
, versionConfig ? import ./versions.nix
, configurationCommon ? import ./configuration-common.nix
, initialPackages ? import ./pypi-packages.nix
}:

let
  inherit (stdenv.lib) callPackageWith extends makeExtensible;

  callPackage = callPackageWith (pkgs // self);

  wheelSrc = fetchurl {
    url = https://pypi.python.org/packages/py2.py3/w/wheel/wheel-0.29.0-py2.py3-none-any.whl;
    sha256 = "1g8f0p8kp1k6kaa3rpbq396401qa84rlsivm5xjlx005k7y3707a";
  };

  pip = runCommand "python${pythonPlatform.version}-pip"
    { buildInputs = [ python ]; }
    ''
      mkdir dist
      ln -s ${wheelSrc} dist/wheel-0.29.0-py2.py3-none-any.whl

      prefix=$(pwd)/.local

      export HOME=$(pwd)
      export PATH=$prefix/bin:$PATH
      export PYTHONPATH=$prefix/${pythonPlatform.sitePackages}

      ${pythonPlatform.python} -m ensurepip --user
      ${pythonPlatform.pip} install wheel==0.29.0 --no-index --find-links ./dist --prefix $prefix

      cp -r $prefix $out

      for f in $out/bin/*; do
          substituteInPlace $f \
              --replace "import sys" "import sys; sys.path.append('$out/${pythonPlatform.sitePackages}')"
      done
    '';

  mkPythonDistInfo = callPackage ./make-distinfo.nix {
    inherit python pip pythonPlatform;
  };

  mkPythonWheel = callPackage ./make-wheel.nix {
    inherit python pip pythonPlatform;
  };

  mkPythonPackage = callPackage ./make-package.nix {
    inherit python pip pythonPlatform mkPythonWheel;
  };

  mkShellEnv = callPackage ./make-virtualenv.nix {
    inherit python virtualenv pythonPlatform self;
  };

  commonConfig = configurationCommon { inherit pkgs pythonPlatform callPackage; };
  initialSet = initialPackages { inherit pkgs pythonPlatform callPackage; };

  packageSet = self: initialSet self // {
    inherit pythonPlatform mkPythonWheel mkPythonPackage mkShellEnv;
    python = python // { mkDerivation = mkPythonPackage; };

    virtualenvWithPackages = withPackages: mkShellEnv {
      inherit withPackages;
    };
  };

  pythonPackages = makeExtensible
    (extends overrides
      (extends interpreterConfig
        (extends commonConfig
          (extends versionConfig packageSet))));

in
  pythonPackages
