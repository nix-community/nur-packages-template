# You can use this file to build packages without adding the NUR namespace
# or the overlay to your configuration.
# It's also useful for testing and working on the packages.
#
# example:
# nix-build ./standalone.nix -A mypackage

with import <nixpkgs> {}; callPackage ./default.nix {}

