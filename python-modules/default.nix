{ pkgs, stdenv, buildEnv, mkShell, runCommand, fetchurl, unzip
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
    { nativeBuildInputs = [ unzip ]; buildInputs = [ python ]; }
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
