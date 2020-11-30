{ pkgs, lib, stdenvNoCC, perl, openjdk11, cacert }:

stdenvNoCC.mkDerivation {
  pname = "opendjk";
  version = "11";
  src = ./.;
  buildInputs = [ perl ];
  installPhase = ''
    # copy original nixos openjdk11 package
    cp -r ${openjdk11} $out
    # Generate certificates
    (
      cd $out/lib/openjdk/lib/security
      chmod +w .
      rm cacerts
      perl ${./generate-cacerts.pl} $out/lib/openjdk/bin/keytool ${cacert}/etc/ssl/certs/ca-bundle.crt
    )
  '';
}
