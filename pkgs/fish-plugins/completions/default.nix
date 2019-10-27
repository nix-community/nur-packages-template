{ stdenv, newScope, sources }:

stdenv.lib.makeScope newScope (
  self: with self; {
    kubectl = callPackage ./kubectl.nix { inherit sources; };
  }
)
