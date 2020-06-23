{ lib, python3Packages, fetchFromGitHub, rofi, xdotool, xsel }:

with python3Packages;

let github = lib.importJSON ./github.json;
in buildPythonApplication rec {
  pname = "rofimoji";
  version = "4.1.0";

  src = fetchFromGitHub {
    inherit (github) owner repo rev sha256;
  };

  propagatedBuildInputs = [ pyxdg ConfigArgParse rofi xdotool xsel ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/fdw/rofimoji";
    description = "A simple emoji and character picker for rofi 😁";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
