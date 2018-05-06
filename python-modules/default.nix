{ pkgs, stdenv, buildEnv, mkShell, runCommand, fetchurl
, python, virtualenv, pythonPlatform, self
, pythonCallPackage ? stdenv.lib.callPackageWith (pkgs // { inherit self; } // self)
, overrides ? (self: super: {})
, interpreterConfig ? (self: super: {})
, versionConfig ? import ./versions.nix
, configurationCommon ? import ./configuration-common.nix
, initialPackages ? import ./pypi-packages.nix
}:

let
  inherit (stdenv.lib) extends makeExtensible;
  callPackage = pythonCallPackage;

  pbrSrc = fetchurl {
    url = https://files.pythonhosted.org/packages/e1/ba/f95e3ec83f93919b1437028e989cf3fa5ff4f5cae4a1f62255f71deddb5b/pbr-4.0.2-py2.py3-none-any.whl;
    sha256 = "4e8a0ed6a8705a26768f4c3da26026013b157821fe5f95881599556ea9d91c19";
  };

  wheelSrc = fetchurl {
    url = https://pypi.python.org/packages/py2.py3/w/wheel/wheel-0.29.0-py2.py3-none-any.whl;
    sha256 = "1g8f0p8kp1k6kaa3rpbq396401qa84rlsivm5xjlx005k7y3707a";
  };

  pip = runCommand "python${pythonPlatform.version}-pip"
    { buildInputs = [ python ]; }
    ''
      mkdir dist
      ln -s ${pbrSrc} dist/pbr-4.0.2-py2.py3-none-any.whl
      ln -s ${wheelSrc} dist/wheel-0.29.0-py2.py3-none-any.whl

      prefix=$(pwd)/.local

      export HOME=$(pwd)
      export PATH=$prefix/bin:$PATH
      export PYTHONPATH=$prefix/${pythonPlatform.sitePackages}

      ${pythonPlatform.python} -m ensurepip --user
      ${pythonPlatform.pip} install wheel==0.29.0 --no-index --find-links ./dist --prefix $prefix
      ${pythonPlatform.pip} install pbr==4.0.2 --no-index --find-links ./dist --prefix $prefix

      cp -r $prefix $out

      for f in $out/bin/*; do
          substituteInPlace $f \
              --replace "import sys" "import sys; sys.path.append('$out/${pythonPlatform.sitePackages}')"
      done
    '';

  mkPythonInfo = callPackage ./make-info.nix {
    inherit python pip pythonPlatform;
  };

  mkPythonWheel = callPackage ./make-wheel.nix {
    inherit python pip pythonPlatform mkPythonInfo;
  };

  mkPythonPackage = callPackage ./make-package.nix {
    inherit python pip pythonPlatform mkPythonWheel;
  };

  mkShellEnv = callPackage ./make-virtualenv.nix {
    inherit python virtualenv pythonPlatform;
  };

  commonConfig = configurationCommon { inherit pkgs callPackage; };
  initialSet = initialPackages { inherit pkgs callPackage; };

  packageSet = self: initialSet self // {
    inherit pythonPlatform callPackage mkPythonInfo mkPythonWheel mkPythonPackage mkShellEnv;
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
