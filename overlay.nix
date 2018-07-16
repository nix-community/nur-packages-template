# You can use this file as a nixpkgs overlay.
# It's useful in the case where you don't want to add the whole NUR namespace
# to your configuration.

self: super:

import ./default.nix {
  callPackage = super.callPackage;
  libsForQt5 = super.libsForQt5;
  haskellPackages = super.haskellPackages;
  pythonPackages = super.pythonPackages;
  # ...
  # Add here other callPackage/callApplication/... providers as the need arises
}

