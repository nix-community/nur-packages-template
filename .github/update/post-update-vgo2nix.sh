#!/usr/bin/env bash
set -e

source ".github/update/utils.sh"

if [ -z "$(git diff)" ] ; then
  quit "👌 there is no change so no reason to update vendors file"
fi

pkgdir=$(cd "$1" ; pwd)

SRC_EXPR="
with import <nixpkgs> {};
let github = lib.importJSON ./github.json;
in fetchFromGitHub {
  inherit (github) owner repo rev sha256;
};
"
SRC_DIR=$(nix-build --expr "$SRC_EXPR")

vgo2nix -dir "$SRC_DIR" -infile "$pkgdir/godeps.nix" -outfile "$pkgdir/godeps.nix"