self: super:

let
  inherit (self) pythonng;
  inherit (super) pkgs stdenv callPackage;

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
  pythonng.interpreter.cpython27 = pythonng.packages.cpython27.python;
  pythonng.interpreter.cpython36 = pythonng.packages.cpython36.python;

  pythonng.packages.cpython27 = callPackage ./python-modules {
    interpreterConfig = import ./python-modules/configuration-2.7.nix;
    python = pkgs.python27;
    virtualenv = pkgs.python27.pkgs.virtualenv;
    pythonPlatform = mkPlatform "cp27" "2.7";

    self = pythonng.packages.cpython27;
  };

  pythonng.packages.cpython36 = callPackage ./python-modules {
    interpreterConfig = import ./python-modules/configuration-3.6.nix;
    python = pkgs.python36;
    virtualenv = pkgs.python36.pkgs.virtualenv;
    pythonPlatform = mkPlatform "cp36" "3.6";

    self = pythonng.packages.cpython36;
  };

  pythonng.jsonIndex = callPackage ./python-modules/json-index.nix {
   self = pythonng.packages.cpython36;
  };
}
