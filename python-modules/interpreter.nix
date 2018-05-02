{ pkgs, stdenv, callPackage
, buildEnv, mkShell, runCommand, fetchurl, unzip
, python, virtualenv, pythonPlatform, self
}:

let
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
in

{
  inherit python pip pythonPlatform mkPythonWheel mkPythonPackage mkShellEnv;

  virtualenvWithPackages = withPackages: mkShellEnv {
    inherit withPackages;
  };
}
