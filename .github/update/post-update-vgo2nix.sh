#!/usr/bin/env bash
set -e

source "$TOOLS"

has_changes_or_quit

pkgdir="$1"

SRC_EXPR="
with import <nixpkgs> {};
let github = lib.importJSON ./github.json;
in fetchFromGitHub {
  inherit (github) owner repo rev sha256;
}
"
SRC_DIR=$(cd "$pkgdir" ; nix-build --expr "$SRC_EXPR")

vgo2nix -dir "$SRC_DIR" -infile "$PWD/$pkgdir/godeps.nix" -outfile "$PWD/$pkgdir/godeps.nix"