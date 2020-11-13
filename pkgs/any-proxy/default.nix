{ lib, buildGoPackage, fetchFromGitHub }:

let github = lib.importJSON ./github.json;
in buildGoPackage {
  pname = "any-proxy";
  version = github.ref;
  goPackagePath = "github.com/ryanchapman/go-any-proxy";
  src = fetchFromGitHub { inherit (github) owner repo rev sha256; };
  goDeps = ./godeps.nix;
  preConfigure = ''
    patch < ${./rename-defaults-files.patch}
    cat <<EOF > version.go
    package main
    const BUILDTIMESTAMP = 0
    const BUILDUSER      = "${github.ref}"
    const BUILDHOST      = "${github.rev}"
    EOF
  '';
  preInstall = "mv -v ./go/bin/go-any-proxy ./go/bin/any-proxy";
}
