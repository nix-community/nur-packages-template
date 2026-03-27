{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "kubectl-netshoot";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "nilic";
    repo = "kubectl-netshoot";
    rev = "v${version}";
    hash = "sha256-4D3cW1g9JWVLuw2xw8kv3ceS9Kg+p4Fu/fz3DCIZHMc=";
  };

  vendorHash = "sha256-x8Jvi+RX63wpyICI2GHqDTteV877evzfCxZDOnkBDWA=";

  meta = {
    description = "A kubectl plugin to easily spin up and access a netshoot container";
    mainProgram = "kubectl-netshoot";
    homepage = "https://github.com/nilic/kubectl-netshoot";
    changelog = "https://github.com/nilic/kubectl-netshoot/releases/tag/v${version}";
    license = lib.licenses.asl20;
  };
}
