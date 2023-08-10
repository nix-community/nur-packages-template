{ lib, rustPlatform, fetchFromGitHub, pkg-config, openssl }:

let
  github = lib.importJSON ./github.json;
  src = fetchFromGitHub { inherit (github) owner repo rev sha256; };
in rustPlatform.buildRustPackage {
  pname = "livebox-cli";
  version = github.ref;

  inherit src;

  cargoLock.lockFile = "${src}/Cargo.lock";
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
