{ pkgs, stdenv, types, callPackage }:

self:

{
  asn1crypto_0_22_0 = callPackage
    ({ mkDerivation }:
     mkDerivation {
       pname = "asn1crypto";
       version = "0.22.0";
       sha256 = "cbbadd640d3165ab24b06ef25d1dca09a3441611ac15f6a6b452474fdf0aed1a";
     }) {};

  cffi_1_10_0 = callPackage
    ({ mkDerivation }:
     mkDerivation {
       pname = "cffi";
       version = "1.10.0";
       sha256 = "b3b02911eb1f6ada203b0763ba924234629b51586f72a21faacc638269f4ced5";
     }) {};

  cryptography_1_9 = callPackage
    ({ mkDerivation }:
     mkDerivation {
       pname = "cryptography";
       version = "1.9";
       sha256 = "5518337022718029e367d982642f3e3523541e098ad671672a90b82474c84882";
     }) {};

  enum34_1_1_6 = callPackage
    ({ mkDerivation }:
     mkDerivation {
       pname = "enum34";
       version = "1.1.6";
       sha256 = "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1";
     }) {};

  idna_2_5 = callPackage
    ({ mkDerivation }:
     mkDerivation {
       pname = "idna";
       version = "2.5";
       sha256 = "3cb5ce08046c4e3a560fc02f138d0ac63e00f8ce5901a56b32ec8b7994082aab";
     }) {};

  ipaddress_1_0_18 = callPackage
    ({ mkDerivation }:
     mkDerivation {
       pname = "ipaddress";
       version = "1.0.18";
       sha256 = "5d8534c8e185f2d8a1fda1ef73f2c8f4b23264e8e30063feeb9511d492a413e1";
     }) {};

  pycparser_2_18 = callPackage
    ({ mkDerivation }:
     mkDerivation {
       pname = "pycparser";
       version = "2.18";
       sha256 = "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226";
     }) {};

  six_1_10_0 = callPackage
    ({ mkDerivation }:
     mkDerivation {
       pname = "six";
       version = "1.10.0";
       sha256 = "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a";
     }) {};
}
