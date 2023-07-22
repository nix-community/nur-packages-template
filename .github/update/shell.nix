{ pkgs ? import <nixpkgs> { } }:

with pkgs;
let
  nixpkgs-22_05 = import (fetchTarball("https://github.com/NixOS/nixpkgs/archive/380be19fbd2d9079f677978361792cb25e8a3635.tar.gz")) {};
in stdenv.mkDerivation {
  name = "auto-update";
  buildInputs = [
    gnupg
    gitAndTools.hub
    jq
    nix-prefetch-github
    nodePackages.node2nix
    nixpkgs-22_05.vgo2nix
  ];
  shellHook = ''
    export GITDIR=$(git rev-parse --show-toplevel)
    export TOOLS="$GITDIR/.github/update/tools.sh"
    source "$TOOLS"
  '';
}
