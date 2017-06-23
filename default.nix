let
  _pkgs = import <nixpkgs> {};
in

{ nixpkgs ? _pkgs.fetchFromGitHub (_pkgs.lib.importJSON ./pkgs/top-level/nixpkgs.json)
, overlays ? []
, ...
} @ args:

let
  packages = import ./pkgs/top-level/all-packages.nix;

  nixpkgsFun = newArgs: import nixpkgs (args // newArgs);

  pkgs = nixpkgsFun {
    overlays = [ packages ] ++ overlays;
  };

in
  pkgs
