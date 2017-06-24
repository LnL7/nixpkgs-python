{ pkgs, stdenv, python, pip, virtualenv
, overrides ? (self: super: {})
, versions ? import ./versions.nix
, configurationCommon ? import ./configuration-common.nix
}:

let

  inherit (stdenv.lib) fix' extends makeExtensible;

  pythonPackages = self:
    let
      fetchpypi = callPackage ./fetchpypi.nix { };
      buildWheel = callPackage ./wheel-builder.nix { };

      mkDerivation = callPackage ./generic-builder.nix { };

      callPackageWithScope = scope: drv: args: (stdenv.lib.callPackageWith scope drv args) // {
        overrideScope = f: callPackageWithScope (mkScope (fix' (extends f scope.__unfix__))) drv args;
      };

      mkScope = scope: pkgs // scope;
      defaultScope = mkScope self;
      callPackage = drv: args: callPackageWithScope defaultScope drv args;

      virtualenvWith = callPackage ./virtualenv-with.nix {
        pythonPackages = self;
      };

      types = {
        tar = "tar.gz";
        tarbz = "tar.bz2";
        tgz = "tgz";
        zip = "zip";
      };

    in
      import ./pypi-packages.nix { inherit pkgs stdenv callPackage types; } self // {
        inherit python pip virtualenv;
        inherit mkDerivation callPackage fetchpypi buildWheel virtualenvWith;
      };

in

  makeExtensible
    (extends overrides
      (extends versions
        (extends configurationCommon pythonPackages)))
