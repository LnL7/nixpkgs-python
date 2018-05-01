{ pkgs ? import <nixpkgs> {
    overlays = [ (import ./pythonng-overlay.nix) ];
  }
, interpreter ? "cpython36"
}:

{ inherit (pkgs) pythonng; }
// pkgs.pythonng.interpreter."${interpreter}"
// pkgs.pythonng.packages."${interpreter}"
