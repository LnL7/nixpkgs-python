self: super:

let
  inherit (super) pkgs stdenv callPackages;
  inherit (self.pythonng) interpreter packages;
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

  pythonng.packages.cpython27 = import ./python-modules/pypi-packages.nix {
    inherit pkgs;
    callPackage = stdenv.lib.callPackageWith (pkgs // interpreter.cpython27 // packages.cpython27);
  };

  pythonng.packages.cpython36 = import ./python-modules/pypi-packages.nix {
    inherit pkgs;
    callPackage = stdenv.lib.callPackageWith (pkgs // interpreter.cpython36 // packages.cpython36);
  };
}
