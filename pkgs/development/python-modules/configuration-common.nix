{ pkgs, stdenv }:

self: super:
let inherit (self) callPackage; in

{
  cffi_1_10_0 = callPackage
    ({ mkDerivation, libffi }:
     mkDerivation {
       src = super.cffi_1_10_0.src;
       systemDepends = [ libffi ];
     }) {};

  cryptography_1_9 = callPackage
    ({ mkDerivation, openssl, cffi, pycparser }:
     mkDerivation {
       src = super.cryptography_1_9.src;
       systemDepends = [ openssl ];
       pythonDepends = [ cffi pycparser ];
     }) {};
}
