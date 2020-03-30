{ stdenvNoCC, lib, fetchurl, rofi, xdotool, xsel, python3, makeWrapper }:

with stdenvNoCC;

mkDerivation rec {
  pname = "rofimoji";
  version = "3.0.0";

  src = fetchurl {
    url = "https://git.teknik.io/matf/${pname}/archive/${version}.tar.gz";
    sha512 =
      "016k8n4hc01305v5qpifg6bxz9gra045q9rj2n6648gnnh84mmb41hzrjpyqrl3mpzv28wyiw56b4fag187pkzf3y508lsxfay9f6s0";
  };

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ python3 rofi ];

  installPhase = ''
    install -D rofimoji.py $out/bin/rofimoji
    wrapProgram $out/bin/rofimoji \
      --prefix PATH : ${lib.makeBinPath [ xdotool xsel ]}
  '';

  meta = with lib; {
    homepage = "https://git.teknik.io/matf/rofimoji";
    description = "A simple emoji picker for rofi with multi-selection";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
