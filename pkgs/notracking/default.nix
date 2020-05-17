{ lib, fetchFromGitHub }:

let github = lib.importJSON ./github.json;
in fetchFromGitHub {
  name = "notracking-${github.ref}";
  inherit (github) owner repo rev sha256;
}
