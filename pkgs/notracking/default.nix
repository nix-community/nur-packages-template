{ lib, fetchFromGitHub }:

let github = lib.importJSON ./github.json;
in fetchFromGitHub {
  name = "notracking";
  inherit (github) owner repo rev sha256;
}
