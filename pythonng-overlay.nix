self: super:

let
  inherit (super) pkgs stdenv callPackages;
  inherit (super.lib) extends makeExtensible;
  inherit (self.pythonng) interpreter packages;

  configurationCommon = import ./python-modules/configuration-common.nix;
  versions = import ./python-modules/versions.nix;
  pypiPackages = import ./python-modules/pypi-packages.nix;

  mkPlatform = abi: version: rec {
    inherit abi version;
    pip = "pip${version}";
    python = "python${version}";
    sitePackages = "lib/${python}/site-packages";
  };

  mkPackageSet = python:
    let
      args = {
        callPackage = stdenv.lib.callPackageWith (pkgs // python);
        inherit (python) pythonPlatform;
        inherit pkgs;
      };
    in
    makeExtensible
      (extends (configurationCommon args)
        (extends (versions args)
          (pypiPackages args)));
in

{
  pythonng.interpreter.cpython27 = callPackages ./python-modules/interpreter.nix {
    python = pkgs.python27;
    virtualenv = pkgs.python27.pkgs.virtualenv;
    pythonPlatform = mkPlatform "cp27" "2.7";
    self = packages.cpython27;
  };

  pythonng.interpreter.cpython36 = callPackages ./python-modules/interpreter.nix {
    python = pkgs.python36;
    virtualenv = pkgs.python36.pkgs.virtualenv;
    pythonPlatform = mkPlatform "cp36" "3.6";
    self = packages.cpython36;
  };

  pythonng.packages.cpython27 = mkPackageSet (interpreter.cpython27 // packages.cpython27);
  pythonng.packages.cpython36 = mkPackageSet (interpreter.cpython36 // packages.cpython36);
}
