self: super:

let
  inherit (super) pkgs stdenv callPackages;
  inherit (super.lib) extends makeExtensible;
  inherit (self.pythonng) interpreter packages;

  cpython27 = interpreter.cpython27 // packages.cpython27;
  cpython36 = interpreter.cpython36 // packages.cpython36;

  versionSet = import ./python-modules/pypi-versions.nix;

  pythonSet = python: pythonPackages: import ./python-modules/pypi-packages.nix {
    callPackage = stdenv.lib.callPackageWith (pkgs // python);
    inherit pkgs pythonPackages;
  };
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

  pythonng.packages.cpython27 = makeExtensible (extends versionSet (pythonSet cpython27));
  pythonng.packages.cpython36 = makeExtensible (extends versionSet (pythonSet cpython36));
}
