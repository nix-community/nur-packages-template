{ pkgs, lib, newScope, recurseIntoAttrs, sources }:
lib.makeScope newScope (
  self: with self; let
    callPackages = lib.callPackagesWith (pkgs // self // { inherit sources; });
    # emacsen = callPackages ./emacs { inherit sources; };
  in
    rec {
      winbox-bin = callPackages ./winbox {};
      winbox = winbox-bin;
      # inherit (emacsen) emacs26 emacs27 emacs27-lucid;

      # fishPlugins = recurseIntoAttrs (callPackages ./fish-plugins { });
    }
)
