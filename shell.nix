{ pkgs ? import <nixpkgs> {} }:

with pkgs;
stdenv.mkDerivation {
  name = "auto-update";
  buildInputs = [ gnupg gitAndTools.hub nodePackages.node2nix ];
}
