self: super:

let
  inherit (super) pkgs stdenv callPackage;
  inherit (self.pythonng) packages;

  mkPlatform = abi: version: rec {
    inherit abi version;
    pip = "pip${version}";
    python = "python${version}";
    sitePackages = "lib/${python}/site-packages";
  };
in

{
  pythonng.interpreter.cpython27 = packages.cpython27.python;
  pythonng.interpreter.cpython36 = packages.cpython36.python;

  pythonng.packages.cpython27 = callPackage ./python-modules {
    interpreterConfig = import ./python-modules/configuration-2.7.nix;
    python = pkgs.python27;
    virtualenv = pkgs.python27.pkgs.virtualenv;
    pythonPlatform = mkPlatform "cp27" "2.7";
  };

  pythonng.packages.cpython36 = callPackage ./python-modules {
    interpreterConfig = import ./python-modules/configuration-3.6.nix;
    python = pkgs.python36;
    virtualenv = pkgs.python36.pkgs.virtualenv;
    pythonPlatform = mkPlatform "cp36" "3.6";
  };
}
