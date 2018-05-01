self: super:

let
  inherit (super) pkgs stdenv callPackages;
  inherit (super.lib) extends makeExtensible;
  inherit (self.pythonng) interpreter packages;

  configurationCommon = import ./python-modules/configuration-common.nix;
  versions = import ./python-modules/versions.nix;
  pypiPackages = import ./python-modules/pypi-packages.nix;

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

    interpreter = interpreter.cpython27;
    packages = packages.cpython27;

    pythonPlatform = rec {
      abi = "cp27";
      version = "2.7";
      pip = "pip${version}";
      python = "python${version}";
      sitePackages = "lib/${python}/site-packages";
    };
  };

  pythonng.interpreter.cpython36 = callPackages ./python-modules/interpreter.nix {
    python = pkgs.python36;
    virtualenv = pkgs.python36.pkgs.virtualenv;

    interpreter = interpreter.cpython36;
    packages = packages.cpython36;

    pythonPlatform = rec {
      abi = "cp36";
      version = "3.6";
      pip = "pip${version}";
      python = "python${version}";
      sitePackages = "lib/${python}/site-packages";
    };
  };

  pythonng.packages.cpython27 = mkPackageSet (interpreter.cpython27 // packages.cpython27);
  pythonng.packages.cpython36 = mkPackageSet (interpreter.cpython36 // packages.cpython36);
}
