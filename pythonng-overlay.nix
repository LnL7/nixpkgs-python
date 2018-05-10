self: super:

let
  inherit (self) pythonng;
  inherit (super) stdenv callPackage recurseIntoAttrs;

  mkPlatform = abi: version: rec {
    inherit abi version;
    isPython27 = version == "2.7";
    isPython36 = version == "3.6";
    pip = "pip${version}";
    python = "python${version}";
    sitePackages = "lib/${python}/site-packages";
  };
in

{
  pythonng = {
    interpreter = recurseIntoAttrs {
      cpython27 = pythonng.packages.cpython27.python;
      cpython36 = pythonng.packages.cpython36.python;
    };

    packages = recurseIntoAttrs {
      cpython27 = callPackage ./python-modules {
        interpreterConfig = import ./python-modules/configuration-2.7.nix;
        python = super.python27;
        virtualenv = super.python27.pkgs.virtualenv;
        pythonPlatform = mkPlatform "cp27" "2.7";
      };

      cpython36 = callPackage ./python-modules {
        interpreterConfig = import ./python-modules/configuration-3.6.nix;
        python = super.python36;
        virtualenv = super.python36.pkgs.virtualenv;
        pythonPlatform = mkPlatform "cp36" "3.6";
      };
    };

    index = import ./python-modules/index.nix {
      inherit stdenv callPackage;
      pythonScope = pythonng.packages.cpython36;
    };
  };
}
