{ pkgs ? import <nixpkgs> {}, sources ? import ./nix/sources.nix }:
with pkgs.lib;
let
  # until 20.03 try to use unstable or upstream version
  niv = if (hasAttrByPath [ "unstable" "niv" ] pkgs) then pkgs.unstable.niv else (import sources.niv {}).niv;
  # until 20.03 try to use unstable or upstream version
  nixpkgs-fmt = if (hasAttrByPath [ "unstable" "nixpkgs-fmt" ] pkgs) then pkgs.unstable.nixpkgs-fmt else (import sources.nixpkgs-fmt {});
  env = pkgs.buildEnv {
    name = "all-packages";
    paths = with pkgs.lib; collect isDerivation (pkgs.callPackages ./non-broken.nix { inherit pkgs; });
  };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    env
    gitAndTools.pre-commit
    niv
    nixpkgs-fmt
    stdenv
  ];
}
