self: super:

let
  inherit (super) pkgs stdenv callPackages;
  inherit (super.lib) extends makeExtensible;
  inherit (self.pythonng) interpreter packages;

  cpython27 = interpreter.cpython27 // packages.cpython27;
  cpython36 = interpreter.cpython36 // packages.cpython36;

  configurationCommon = import ./python-modules/configuration-common.nix;
  versions = import ./python-modules/versions.nix;

  pypiPackages = python: import ./python-modules/pypi-packages.nix {
    callPackage = stdenv.lib.callPackageWith (pkgs // python);
    inherit (python) pythonPlatform;
    inherit pkgs;
  };

  mkPackageSet = python:
    makeExtensible
      (extends configurationCommon
        (extends versions (pypiPackages python)));
in

{
  pythonng.interpreter.cpython27 = callPackages ./python-modules/interpreter.nix {
    python = pkgs.python27;

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

    pythonPlatform = rec {
      abi = "cp36";
      version = "3.6";
      pip = "pip${version}";
      python = "python${version}";
      sitePackages = "lib/${python}/site-packages";
    };
  };

  pythonng.packages.cpython27 = mkPackageSet cpython27;
  pythonng.packages.cpython36 = mkPackageSet cpython36;
}
