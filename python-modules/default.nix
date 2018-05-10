{ pkgs, stdenv, callPackage
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

  pip = callPackage ./pip.nix {
    inherit python pythonPlatform;
  };

  commonConfig = configurationCommon { inherit pkgs; };

  packageSet = callPackage ./package-set.nix {
    inherit python pip virtualenv pythonPlatform;
    inherit pythonCallPackage;
    packageSet = initialPackages;
  };

  pythonPackages = makeExtensible
    (extends overrides
      (extends interpreterConfig
        (extends commonConfig
          (extends versionConfig packageSet))));

in
  pythonPackages
