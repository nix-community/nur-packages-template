{
  pkgs ? import <nixpkgs> { },
}:

let
  self = import ./getFlake.nix ./.;
  inherit (pkgs) lib;
in
lib.recursiveUpdate {
  inherit (self) lib modules overlays;
} (self.fromPkgs pkgs)
