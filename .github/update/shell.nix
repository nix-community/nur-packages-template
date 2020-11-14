{ pkgs ? import <nixpkgs> { } }:

with pkgs;
stdenv.mkDerivation {
  name = "auto-update";
  buildInputs = [
    gnupg
    gitAndTools.hub
    jq
    nix-prefetch-github
    miller
    nodePackages.node2nix
    vgo2nix
  ];
  shellHook = ''
    export GITDIR=$(git rev-parse --show-toplevel)
    export TOOLS="$GITDIR/.github/update/tools.sh"
    source "$TOOLS"
  '';
}
