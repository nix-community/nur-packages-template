{ lib, buildGoPackage, fetchFromGitHub }:

let github = lib.importJSON ./github.json;
in buildGoPackage {
  pname = "jfrog-cli";
  version = github.ref;
  goPackagePath = "github.com/jfrog/jfrog-cli";
  src = fetchFromGitHub { inherit (github) owner repo rev sha256; };
  goDeps = ./godeps.nix;
  # remove testsdata dir because it uses unreferenced dependencies
  preConfigure = "rm -rf testdata";
  preInstall = "mv -v ./go/bin/jfrog-cli ./go/bin/jfrog";
}
