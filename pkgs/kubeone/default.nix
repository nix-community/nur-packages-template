{ stdenvNoCC, lib, fetchzip }:

let
  github = lib.importJSON ./github-release.json;
  version = lib.strings.removePrefix "v" github.ref;
  url = "https://github.com/kubermatic/kubeone/releases/download/${github.ref}/kubeone_${version}_linux_amd64.zip";
in stdenvNoCC.mkDerivation {
  pname = "kubeone";
  inherit version;

  src = fetchzip {
    inherit url;
    hash = github.hash;
    stripRoot = false;
  };

  installPhase = ''
    install -Dm755 kubeone "$out/bin/kubeone"
  '';

  meta = with lib; {
    homepage = "https://github.com/kubermatic/kubeone";
    description = "Kubermatic KubeOne automate cluster operations on all your cloud, on-prem, edge, and IoT environments.";
    license = licenses.asl20;
    platforms = platforms.x86_64;
    maintainers = [ ];
  };
}
