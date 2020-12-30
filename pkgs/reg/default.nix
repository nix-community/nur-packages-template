{ stdenvNoCC, lib, fetchurl }:

let
  github = lib.importJSON ./github-release-assets.json;
  version = lib.strings.removePrefix "v" github.ref;
in stdenvNoCC.mkDerivation {
  pname = "reg-cli";
  inherit version;

  src = let
    platformName = {
      x86_64-linux = "linux-amd64";
      x86_64-darwin = "darwin-amd64";
    }.${stdenvNoCC.hostPlatform.system} or (throw
      "unsupported system ${stdenvNoCC.hostPlatform.system}");
  in fetchurl {
    name = "reg-${version}-${stdenvNoCC.hostPlatform.system}";
    url = github.assets."reg-${platformName}".url;
    hash = github.assets."reg-${platformName}".hash;
  };

  dontUnpack = true;

  installPhase = ''
    ls -l $src
    install -Dm755 $src "$out/bin/reg"
  '';

  meta = with lib; {
    homepage = "https://github.com/genuinetools/reg";
    description =
      "Docker registry v2 command line client and repo listing generator with security checks";
    license = licenses.mit;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = [ ];
  };
}
