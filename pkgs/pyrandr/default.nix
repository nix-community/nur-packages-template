{ stdenvNoCC, fetchFromGitHub, python3, xrandr }:

with stdenvNoCC;

let github = lib.importJSON ./github.json;
in mkDerivation {
  pname = "pyrandr";
  version = github.ref;

  src = fetchFromGitHub { inherit (github) owner repo rev sha256; };

  buildInputs = [ python3 xrandr ];

  installPhase = ''
    install -vDm755 pyrandr.py "$out/bin/pyrandr"
  '';

  meta = with lib; {
    description =
      "xrandr python wrapper for better screen scale and positioning ";
    license = licenses.unlicense;
    homepage = "https://github.com/jeremiehuchet/pyrandr";
    platforms = platforms.all;
  };
}
