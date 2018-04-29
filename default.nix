{ pkgs ? import <nixpkgs> {
    overlays = [ (import ./pythonng-overlay.nix) ];
  }
, interpreter ? "cpython36"
}:

pkgs.pythonng.packages."${interpreter}"
