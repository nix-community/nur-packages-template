{ pkgs ? import <nixpkgs> {} }:

with pkgs;
stdenv.mkDerivation {
  name = "auto-update";
  buildInputs = [ gnupg nodePackages.node2nix ];
}
