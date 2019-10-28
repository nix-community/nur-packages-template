{ pkgs, lib, newScope, recurseIntoAttrs, sources }:
lib.makeScope newScope (
  self: with self; let
    packagePlugin = callPackage ./package-plugin.nix {};
    callPackages = lib.callPackagesWith (pkgs // self // { inherit sources packagePlugin; });
  in
    {
      completions = recurseIntoAttrs (callPackages ./completions {});

      pure = packagePlugin rec {
        name = "fish-pure-${version}";
        version = sources.fish-pure.version;
        src = sources.fish-pure;
        meta.license = lib.licenses.mit;
      };
    }
)
