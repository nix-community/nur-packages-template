{ lib, rustPlatform, fetchFromGitHub, pkg-config, openssl }:

let
  github = lib.importJSON ./github.json;
in rustPlatform.buildRustPackage {
  pname = "livebox-cli";
  version = github.ref;

  src = fetchFromGitHub { inherit (github) owner repo rev sha256; };

  cargoSha256 = "G61z7jgPRjmnfn7TEh9k2nMIFFU5GDpcfUbdiKGvkE4=";

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    openssl
  ];

  meta = with lib; {
    description =
      "livebox-cli is a command line interface to interact with Orange Livebox";
    license = licenses.mit;
    homepage = "https://github.com/jeremiehuchet/livebox-cli";
  };
}
