{ stdenvNoCC, fetchFromGitHub }:

with stdenvNoCC;

let github = lib.importJSON ./github.json;
in mkDerivation rec {
  pname = "nix-direnv";
  version = github.ref;

  src = fetchFromGitHub { inherit (github) owner repo rev sha256; };

  installPhase = ''
    install -Dm644 direnvrc "$out/share/nix-direnv/direnvrc"
  '';

  meta = with lib; {
    description = "A fast, persistent use_nix implementation for direnv";
    license = licenses.mit;
    homepage = "https://github.com/nix-community/nix-direnv";
    platforms = platforms.all;
  };
}
