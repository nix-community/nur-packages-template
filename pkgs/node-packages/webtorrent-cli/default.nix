{ pkgs, lib, stdenvNoCC, nodejs-12_x }:

with import ../../../lib { inherit pkgs; };

mkNodeDerivation {
  pname = "webtorrent-cli";
  version = "3.0.0";
  hash = "sha256:0xw0vdr8a6pim62531ch3y6r2ld4x4k3hj1il674156lm3pjzw3d";
  commands = [ "webtorrent" ];
  meta = with lib; {
    description =
      "WebTorrent, the streaming torrent client. For the command line.";
    license = licenses.mit;
    homepage = "https://webtorrent.io";
    platforms = [ "x86_64-linux" ];
  };
}
