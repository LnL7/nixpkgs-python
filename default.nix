{ pkgs ? import <nixpkgs> {
    overlays = [ (import ./pythonng-overlay.nix) ];
  }
, interpreter ? "cpython36"
}:

{ inherit (pkgs) pythonng; }
// pkgs.pythonng.packages."${interpreter}"
