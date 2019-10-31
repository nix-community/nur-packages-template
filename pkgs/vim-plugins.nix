{ lib, newScope, pkgs, sources, vimUtils }:
with lib;
makeScope newScope (
  self: with self; let
    callPackages = lib.callPackagesWith (pkgs // self // { inherit sources; });
  in
    {
      vim-bbye = vimUtils.buildVimPluginFrom2Nix {
        pname = "vim-bbye";
        version = sources.vim-bbye.version;
        src = sources.vim-bbye;
        meta = {
          inherit (sources.vim-bbye) description homepage;
          license = licenses.agpl3;
          platform = platforms.all;
        };
      };
      vim-sideways = vimUtils.buildVimPluginFrom2Nix {
        pname = "vim-sideways";
        version = sources.vim-sideways.version;
        src = sources.vim-sideways;
        meta = {
          inherit (sources.vim-sideways) description homepage;
          license = licenses.mit;
          platform = platforms.all;
        };
      };
    }
)
