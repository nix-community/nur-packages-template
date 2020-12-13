{ stdenv, sources ? import ../../../nix/sources.nix {} }:

stdenv.mkDerivation {
  pname = "rpi-vc-log";
  version = "unstable-2020-06-11";

  src = sources.rpi-vc-log;

  installPhase = ''
    mkdir -p $out/bin
    cp vc-log $out/bin
  '';
}
