{ pkgs, stdenv, makeSetupHook, python, pip, virtualenv, pythonPlatform
, pythonCallPackage ? null
, packageSet
}:

self:

let
  inherit (stdenv.lib) fix' extends makeOverridable;

  mkScope = scope: pkgs // { pythonScope = scope; } // scope;
  defaultScope = mkScope self;

  callPackage = if pythonCallPackage != null
    then pythonCallPackage
    else stdenv.lib.callPackageWith defaultScope;

  pipHook = makeSetupHook
    { substitutions = { inherit (pythonPlatform) pip sitePackages; }; }
    ./pip/setup-hook.sh;

  virtualenvHook = makeSetupHook
    { deps = [ pipHook ]; }
    ./virtualenv/setup-hook.sh;

  mkPythonInfo = pkgs.callPackage ./info-builder.nix {
    inherit pip;
    inherit (self) python pythonPlatform;
  };

  mkPythonWheel = pkgs.callPackage ./wheel-builder.nix {
    inherit pip;
    inherit (self) python pythonPlatform pipHook mkPythonInfo;
    pythonScope = self;
  };

  mkPythonDerivation = pkgs.callPackage ./generic-builder.nix {
    inherit pip;
    inherit (pkgs.xlibs) lndir;
    inherit (self) python pythonPlatform pipHook mkPythonWheel mkShellEnv;
    pythonScope = self;
  };

  mkPython = pkgs.callPackage ./make-python.nix {
    inherit (self) python pythonPlatform;
    pythonScope = self;
  };

  mkPythonEnv = pkgs.callPackage ./make-environment.nix {
    inherit (self) python pythonPlatform;
    inherit (pkgs.xlibs) lndir;
    pythonScope = self;
  };

  mkShellEnv = pkgs.callPackage ./make-virtualenv.nix {
    inherit virtualenv;
    inherit (self) python pythonPlatform virtualenvHook mkPythonEnv;
    pythonScope = self;
  };
in

packageSet { inherit pkgs callPackage; } self // {
  inherit callPackage pipHook virtualenvHook pythonPlatform;
  inherit mkPython mkPythonInfo mkPythonWheel mkPythonDerivation mkPythonEnv mkShellEnv;

  python = python // {
    inherit pip;
    mkDerivation = self.mkPythonDerivation;
  };

  pythonWithPackages = withPackages: self.mkPython {
    inherit withPackages;
  };

  virtualenvWithPackages = withPackages: self.mkShellEnv {
    inherit withPackages;
  };
}
