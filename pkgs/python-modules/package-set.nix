{ pkgs, stdenv, python, pip, virtualenv, pythonPlatform
, pythonCallPackage ? null
, packageSet
}:

self:

let
  inherit (stdenv.lib) fix' extends makeOverridable;

  mkScope = scope: pkgs // { pythonScope = scope; } // scope;
  defaultScope = mkScope self;

  callPackage = if pythonCallPackage != null
    then pythonCallPackage
    else stdenv.lib.callPackageWith defaultScope;

  mkPythonInfo = pkgs.callPackage ./info-builder.nix {
    inherit pip;
    inherit (self) python pythonPlatform;
  };

  mkPythonWheel = pkgs.callPackage ./wheel-builder.nix {
    inherit pip;
    inherit (self) python pythonPlatform mkPythonInfo;
    pythonScope = self;
  };

  mkPythonDerivation = pkgs.callPackage ./generic-builder.nix {
    inherit pip;
    inherit (self) python pythonPlatform mkPythonWheel;
    pythonScope = self;
  };

  mkPythonEnv = pkgs.callPackage ./make-python.nix {
    inherit (self) python pythonPlatform;
    pythonScope = self;
  };

  mkShellEnv = pkgs.callPackage ./make-virtualenv.nix {
    inherit virtualenv;
    inherit (self) python pythonPlatform;
    pythonScope = self;
  };
in

packageSet { inherit pkgs callPackage; } self // {
  inherit callPackage pythonPlatform mkPythonInfo mkPythonWheel mkPythonDerivation mkPythonEnv mkShellEnv;

  python = python // {
    inherit pip;
    mkDerivation = self.mkPythonDerivation;
  };

  pythonWithPackages = withPackages: self.mkPythonEnv {
    inherit withPackages;
  };

  virtualenvWithPackages = withPackages: self.mkShellEnv {
    inherit withPackages;
  };
}
