{ lib, newScope, pkgs, sources, vimUtils }:
lib.makeScope newScope (
  self: with self; let
    callPackages = lib.callPackagesWith (pkgs // self // { inherit sources; });
  in
    {
      vim-bbye = vimUtils.buildVimPluginFrom2Nix {
        pname = "vim-bbye";
        version = sources.vim-bbye.version;
        src = sources.vim-bbye;
      };
      vim-sideways = vimUtils.buildVimPluginFrom2Nix {
        pname = "vim-sideways";
        version = sources.vim-sideways.version;
        src = sources.vim-sideways;
      };
    }
)
