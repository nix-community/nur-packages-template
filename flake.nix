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
      modulesDir = "${self}/overlays";
      # TODO: Consider upstreaming to nixpkgs.lib
      readDirRecursive =
        path:
        lib.mapAttrs (
          path': type:
          (if (type == "directory" || type == "symlink") then readDirRecursive "${path}/${path'}" else type)
        ) (builtins.readDir path);
      initValueAtPath =
        path: value:
        if lib.length path == 0 then
          value
        else
          { ${lib.head path} = initValueAtPath (lib.tail path) value; };
      attrNamesRecursive = lib.mapAttrsToList (
        name: value:
        if lib.isAttrs value then lib.map (path: [ name ] ++ path) (attrNamesRecursive value) else [ name ]
      );
      filterAttrsRecursive' =
        filter: attrs:
        lib.mapAttrs (
          name: value:
          if lib.isAttrs value then
            filterAttrsRecursive' (path: value': filter ([ name ] ++ path) value') value
          else
            value
        ) (lib.filterAttrs (name: value: (lib.isAttrs value) || (filter [ name ] value)) attrs);
      mapAttrsRecursive' =
        mapping: attrs:
        lib.foldlAttrs (
          acc: name: value:
          let
            result =
              if lib.isAttrs value then
                mapAttrsRecursive' (path': value': mapping ([ name ] ++ path') value') value
              else
                let
                  mapped = mapping [ name ] value;
                in
                initValueAtPath mapped.path mapped.value;
          in
          lib.recursiveUpdate acc result
        ) { } attrs;
      filterAndMapAttrsRecursive' =
        filter: mapping: attrs:
        mapAttrsRecursive' mapping (filterAttrsRecursive' filter attrs);
    in
    flake-parts.lib.mkFlake { inherit inputs; } (
      top@{
        config,
        withSystem,
        moduleWithSystem,
        ...
      }:
      {
        flake = {
          lib = (import libDir { pkgs.lib = lib; });
          overlays =
            filterAndMapAttrsRecursive'
              (path: value: (lib.hasSuffix ".nix" (lib.last path)) && value == "regular")
              (path: _: {
                path = (lib.dropEnd 1 path) ++ [ (lib.removeSuffix ".nix" (lib.last path)) ];
                value = (import (lib.concatStringsSep "/" ([ overlaysDir ] ++ path)));
              })
              (readDirRecursive overlaysDir);
          modules =
            filterAndMapAttrsRecursive'
              (path: value: (lib.hasSuffix ".nix" (lib.last path)) && value == "regular")
              (path: _: {
                path = (lib.dropEnd 1 path) ++ [ (lib.removeSuffix ".nix" (lib.last path)) ];
                value = (import (lib.concatStringsSep "/" ([ modulesDir ] ++ path)));
              })
              (readDirRecursive modulesDir);
          fromPkgs =
            pkgs:
            lib.mapAttrs (_: f: f { }) (
              lib.fix (
                nurPkgs:
                filterAndMapAttrsRecursive' (path: value: (lib.last path == "package.nix") && value == "regular") (
                  path: _: {
                    path = lib.dropEnd 1 path;
                    value =
                      _:
                      lib.callPackageWith (lib.recursiveUpdate pkgs (lib.mapAttrs (_: f: f { }) nurPkgs)) (
                        lib.concatStringsSep
                        "/"
                        ([ pkgsDir ] ++ path)
                      ) { };
                  }) (readDirRecursive pkgsDir)
              )
            );
        };
        systems = lib.systems.flakeExposed;
        perSystem =
          {
            self',
            config,
            pkgs,
            ...
          }:
          {
            legacyPackages = (self.fromPkgs pkgs) // {
              inherit (self) lib overlays modules;
            };
            packages = lib.filterAttrs (_: lib.isDerivation) self'.legacyPackages;

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
