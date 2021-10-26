{ pkgs, lib, python3Packages, fetchFromGitHub, rofi, xdotool, xsel, fetchpatch}:

with python3Packages;

let
  github = lib.importJSON ./github.json;
  pyxdg-0_26 = pkgs.callPackage ./pyxdg-0.26.nix {
    inherit lib buildPythonPackage fetchPypi fetchpatch;
  };
in buildPythonApplication rec {
  pname = "rofimoji";
  version = github.ref;

  format = "pyproject";

  src = fetchFromGitHub {
    inherit (github) owner repo rev sha256;
  };

  propagatedBuildInputs = [ pyxdg-0_26 ConfigArgParse rofi xdotool xsel ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/fdw/rofimoji";
    description = "A simple emoji and character picker for rofi 😁";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
