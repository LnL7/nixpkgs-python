{ interpreter ? builtins.readFile ./python-version
, pkgs ? import <nixpkgs> {
    overlays = [ (import ./pythonng-overlay.nix) ];
  }
}:

{ inherit (pkgs) pythonng; }
// pkgs.pythonng.packages."${interpreter}"
