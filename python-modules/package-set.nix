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

  mkPythonInfo = pkgs.callPackage ./make-info.nix {
    inherit pip;
    inherit (self) python pythonPlatform;
  };

  mkPythonWheel = pkgs.callPackage ./make-wheel.nix {
    inherit pip;
    inherit (self) python pythonPlatform mkPythonInfo;
  };

  mkPythonPackage = pkgs.callPackage ./make-package.nix {
    inherit pip;
    inherit (self) python pythonPlatform mkPythonWheel;
  };

  mkShellEnv = pkgs.callPackage ./make-virtualenv.nix {
    inherit virtualenv;
    inherit (self) python pythonPlatform;
    pythonScope = self;
  };
in

packageSet { inherit pkgs callPackage; } self // {
  inherit callPackage pythonPlatform mkPythonInfo mkPythonPackage mkPythonWheel mkShellEnv;

  python = python // {
    mkDerivation = self.mkPythonPackage;
  };

  virtualenvWithPackages = withPackages: self.mkShellEnv {
    inherit withPackages;
  };
}
