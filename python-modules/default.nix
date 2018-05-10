{ pkgs, stdenv, buildEnv, mkShell, runCommand, fetchurl
, python, virtualenv, pythonPlatform
, pythonCallPackage ? null
, overrides ? (self: super: {})
, interpreterConfig ? (self: super: {})
, versionConfig ? import ./versions.nix
, configurationCommon ? import ./configuration-common.nix
, initialPackages ? import ./pypi-packages.nix
}:

let
  inherit (stdenv.lib) extends makeExtensible;

  callPackage = if pythonCallPackage != null
    then pythonCallPackage
    else stdenv.lib.callPackageWith pythonScope;

  pythonScope = pkgs // { inherit pythonPlatform; } // pythonPackages;

  pip = callPackage ./pip.nix {
    inherit python pythonPlatform;
  };

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
    inherit python virtualenv pythonPlatform pythonScope;
  };

  commonConfig = configurationCommon { inherit pkgs callPackage; };
  initialSet = initialPackages { inherit pkgs callPackage; };

  packageSet = self: initialSet self // {
    inherit callPackage mkPythonInfo mkPythonWheel mkPythonPackage mkShellEnv;
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
