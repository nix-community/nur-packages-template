{ lib, newScope, sources, packagePlugin }:
lib.makeScope newScope (
  self: with self; {
    kubectl = callPackage ./kubectl.nix { inherit packagePlugin sources; };
  }
)
