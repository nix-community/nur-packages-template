# This file describes your repository contents.
# It should return a set of nix derivations.
# It should NOT import <nixpkgs>. Instead, you should take all dependencies as
# arguments.

{ callPackage
, libsForQt5
, haskellPackages
, pythonPackages
# , ...
# Add here other callPackage/callApplication/... providers as the need arises
, ... }:

{
  example-package = callPackage ./pkgs/example-package { };
  # some-qt5-package = libsForQt5.callPackage ./pkgs/some-qt5-package { };
  # ...
}

