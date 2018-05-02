{ pkgs ? import <nixpkgs> {}, interpreter ? builtins.readFile ./python-version }:

let
  inherit (versions."${interpreter}".pkgs) callPackage;

  versions = {
    cpython27 = pkgs.python27;
    cpython36 = pkgs.python36;
  };
in

callPackage
  ({ stdenv, jq, ipython, pip, pipenv }:
   stdenv.mkDerivation rec {
     name = "pipenv2nix-${version}";
     version = "0.1.0";

     buildInputs = [ jq ipython pip pipenv ];

     shellHook = ''
       export PATH=${toString ./bin}:$PATH
       export PIPENV_CACHE_DIR=$HOME/.cache/pipenv
     '';
   }) {}
