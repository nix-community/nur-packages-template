{ stdenvNoCC, fetchFromGitHub, python3, xrandr }:

with stdenvNoCC;

mkDerivation {
  name = "pyrandr";

  src = fetchFromGitHub {
    owner = "jeremiehuchet";
    repo = "pyrandr";
    rev = "master";
    sha512 =
      "1d77vx9py8mgkshayazc361mxkkd721ks6qczrw7dy9sg6rhrq05j9r40hd5pg0j8ll20r2dnkvk9ii8r6m6fmrhv33g1kgn42lfnlb";
  };

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
    maintainers = with maintainers; [ ];
  };
}
