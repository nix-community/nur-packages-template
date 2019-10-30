{ pkgs, lib, newScope, recurseIntoAttrs, sources }:
lib.makeScope newScope (
  self: with self; let
    callPackages = lib.callPackagesWith (pkgs // self // { inherit sources; });
  in
    rec {
      fishPlugins = recurseIntoAttrs (callPackages ./fish-plugins {});
      lsColors = callPackages ./ls-colors.nix {};
      vimPlugins = recurseIntoAttrs (callPackages ./vim-plugins.nix {});
      winbox-bin = callPackages ./winbox {};
      winbox = winbox-bin;
    }
)
