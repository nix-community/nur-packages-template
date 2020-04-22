# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> { } }:

{
  # The `lib`, `modules`, and `overlay` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  bazarr = pkgs.callPackage ./pkgs/bazarr { };
  ccat = pkgs.callPackage ./pkgs/ccat { };
  dbvisualizer = pkgs.callPackage ./pkgs/dbvisualizer { };
  gitmoji-cli = pkgs.callPackage ./pkgs/node-packages/gitmoji-cli/fixed.nix { };
  jfrog-cli = pkgs.callPackage ./pkgs/jfrog-cli { };
  kubeone = pkgs.callPackage ./pkgs/kubeone { };
  nix-direnv = pkgs.callPackage ./pkgs/nix-direnv { };
  networkmanager-ssh = pkgs.callPackage ./pkgs/networkmanager-ssh { };
  notracking = pkgs.callPackage ./pkgs/notracking { };
  now = pkgs.callPackage ./pkgs/node-packages/now/fixed.nix { };
  pyrandr = pkgs.callPackage ./pkgs/pyrandr { };
  rofi-bookmarks = pkgs.callPackage ./pkgs/rofi-bookmarks { };
  rofimoji = pkgs.callPackage ./pkgs/rofimoji { };
  webtorrent-cli =
    pkgs.callPackage ./pkgs/node-packages/webtorrent-cli/fixed.nix { };
  yaml2json = pkgs.callPackage ./pkgs/yaml2json { };
}
