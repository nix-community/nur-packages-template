{
  description = "My personal NUR repository";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      pkgsDir = "${self}/pkgs";
      libDir = "${self}/lib";
      overlaysDir = "${self}/overlays";
      modulesDir = "${self}/modules";
    in
    flake-parts.lib.mkFlake { inherit inputs; } (
      top@{
        config,
        withSystem,
        moduleWithSystem,
        ...
      }:
      let
        ourLib = (import libDir { inherit lib; });
        lib' = lib.recursiveUpdate lib ourLib;
      in
      {
        flake = {
          lib = ourLib;
          overlays = lib'.importDirRecursive overlaysDir;
          modules = lib'.importDirRecursive modulesDir;
        };
        systems = lib.systems.flakeExposed;
        perSystem =
          {
            self',
            config,
            pkgs,
            ...
          }:
          let
            pkgs' = lib.recursiveUpdate pkgs { lib = lib'; };
            ourPackages = lib'.callDirPackageWithRecursive pkgs' pkgsDir;
          in
          {
            legacyPackages = ourPackages // {
              inherit (self) lib overlays modules;
              maintainers = pkgs.callPackage "${self}/maintainers" { };
            };
            packages = lib.filterAttrs (_: lib.isDerivation) ourPackages;

            formatter = pkgs.treefmt.withConfig {
              runtimeInputs = with pkgs; [
                nixfmt-rfc-style
                black
                yamlfmt
                markdownlint-cli2
              ];

              settings = {
                on-unmatched = "info";
                tree-root-file = "flake.nix";

                formatter = {
                  nixfmt = {
                    command = "nixfmt";
                    includes = [ "*.nix" ];
                  };
                  black = {
                    command = "black";
                    includes = [ "*.py" ];
                  };
                  yamlfmt = {
                    command = "yamlfmt";
                    includes = [ "*.yml" ];
                  };
                  markdownlint = {
                    command = "markdownlint-cli2";
                    options = [ "--fix" ];
                    includes = [ "*.md" ];
                  };
                };
              };
            };
          };
      }
    );
}
