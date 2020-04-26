{ pkgs, lib, stdenvNoCC, fetchurl }:

let
  fetchGitHubReleaseBinary = { owner, repo, relVersion, asset, sha256 }:
    fetchurl {
      name = "github-release-${repo}-${relVersion}";
      url =
        "https://github.com/${owner}/${repo}/releases/download/${relVersion}/${asset}";
      inherit sha256;
    };
  pname = "yaml2json";
  version = "1.3";
in stdenvNoCC.mkDerivation {
  inherit pname version;
  src = fetchGitHubReleaseBinary {
    owner = "bronze1man";
    repo = pname;
    relVersion = "v${version}";
    asset = "yaml2json_linux_amd64";
    sha256 = "e792647dd757c974351ea4ad35030852af97ef9bbbfb9594f0c94317e6738e55";
  };
  unpackPhase = ":";
  installPhase = ''
    ls -l
    mkdir -p $out/bin
    install -m755 $src $out/bin/yaml2json
  '';
  meta = {
    homepage = "https://github.com/bronze1man/yaml2json";
    description = "A command line tool convert from yaml to json";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}

