{ pkgs ? import <nixpkgs> {}, interpreter ? "python36" }:

let
  inherit (pkgs.${interpreter}.pkgs) callPackage;
in

callPackage
  ({ stdenv, jq, pip, pipenv }:
   stdenv.mkDerivation rec {
     name = "pipenv2nix-${version}";
     version = "0.1.0";

     buildInputs = [ jq pip pipenv ];

     shellHook = ''
       export PATH=${toString ./bin}:$PATH
       export PIPENV_CACHE_DIR=$HOME/.cache/pipenv
     '';
   }) {}
