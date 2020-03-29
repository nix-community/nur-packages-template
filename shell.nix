{ pkgs ? import <nixpkgs> {} }:

with pkgs;
stdenv.mkDerivation {
  name = "auto-update";
  buildInputs = [ git gnupg nodePackages.node2nix ];
}
