{ stdenvNoCC, fetchFromGitHub, nodejs-12_x, rofi }:

with stdenvNoCC;


let github = lib.importJSON ./github.json;
in mkDerivation {
  pname = "rofi-bookmarks";
  version = github.ref;

  src = fetchFromGitHub { inherit (github) owner repo rev sha256; };

  buildInputs = [ nodejs-12_x ];

  installPhase = ''
    mkdir -p $out/bin $out/share/rofi-bookmarks
    install -Dm755 rofi-modi-bookmarks.js $out/share/rofi-bookmarks
    cat - <<EOF > $out/bin/rofi-bookmarks
    #!/bin/sh
    exec ${rofi}/bin/rofi -modi bookmarks:"$out/share/rofi-bookmarks/rofi-modi-bookmarks.js" -show bookmarks
    EOF
    chmod +x $out/bin/rofi-bookmarks
  '';

  meta = with lib; {
    description = "Rofi script to open chrome bookmarks";
    license = licenses.mit;
    homepage = "https://github.com/jeremiehuchet/rofi-bookmarks";
    platforms = platforms.all;
  };
}
