{ stdenvNoCC, fetchFromGitHub, nodejs-12_x, rofi }:

with stdenvNoCC;

mkDerivation {
  name = "rofi-bookmarks";

  src = fetchFromGitHub {
    owner = "jeremiehuchet";
    repo = "rofi-bookmarks";
    rev = "master";
    sha512 =
      "256kdd6k77bqz6lj712j6l5mf1fwsjk806hvxk2wvwrc1v8i9dyz35cg3ny7ki5hi1p46lib7x6mf1qdfq2c3nd0bhlcs0cznjdc5fv";
  };

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
    maintainers = with maintainers; [ ];
  };
}
