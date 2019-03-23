# This file filters out all the broken packages from your package set.
# It's what gets built by CI, so if you correctly mark broken packages as
# broken your CI will not try to build them and the non-broken packages will
# be added to the cache.
{ pkgs ? import <nixpkgs> {} }:

let
  filterSet =
    (f: g: s: builtins.listToAttrs
      (map
        (n: { name = n; value = builtins.getAttr n s; })
        (builtins.filter
          (n: f n && g (builtins.getAttr n s))
          (builtins.attrNames s)
        )
      )
    );
  isReserved = n: builtins.elem n ["lib" "overlays" "modules"];
  isBroken = p: ({ meta.broken = false; } // p).meta.broken;
  isFree = p: ({ meta.license.free = true; } // p).meta.license.free;
in filterSet
     (n: !(isReserved n)) # filter out non-packages
     (p: (builtins.isAttrs p)
       && !(isBroken p)
       && isFree p
     )
     (import ./default.nix { inherit pkgs; })

