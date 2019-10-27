{ pkgs, stdenv, lib, newScope, recurseIntoAttrs, sources }:

stdenv.lib.makeScope newScope (
  self: with self; let
    callPackages = lib.callPackagesWith (pkgs // self // { inherit sources; });
  in
    {
      packagePlugin = callPackage ./package-plugin.nix {};

      completions = recurseIntoAttrs (callPackages ./completions {});

      pure = packagePlugin rec {
        name = "fish-pure-${version}";
        version = sources.fish-pure.version;
        src = sources.fish-pure;
        meta.license = lib.licenses.mit;
      };
    }
)
