{ pkgs ? import <nixpkgs> {}, sources ? import ./nix/sources.nix }:
with pkgs.lib;
let
  # until 20.03 try to use unstable or upstream version
  niv = if (hasPrefix "0.2." pkgs.haskellPackages.niv.version) then pkgs.haskellPackages.niv else if (hasAttrByPath [ "unstable" "haskellPackages" "niv" ] pkgs) then pkgs.unstable.haskellPackages.niv else (import sources.niv {}).niv;
  # until 20.03 try to use unstable or upstream version
  nixpkgs-fmt = if (hasPrefix "0.6." pkgs.nixpkgs-fmt.version) then pkgs.nixpkgs-fmt else if (hasAttrByPath [ "unstable" "nixpkgs-fmt" ] pkgs) then pkgs.unstable.nixpkgs-fmt else (import sources.nixpkgs-fmt {});
  env = pkgs.buildEnv {
    name = "all-packages";
    paths = (import ./ci.nix { inherit pkgs; }).buildPkgs;
  };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    direnv
    env
    gitAndTools.pre-commit
    niv
    nixpkgs-fmt
    stdenv
    vgo2nix
  ];
}
