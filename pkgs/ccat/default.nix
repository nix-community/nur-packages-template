{ stdenvNoCC, fetchurl }:

with stdenvNoCC;

mkDerivation rec {
  pname = "ccat";
  version = "1.1.0";

  src = fetchurl {
    url =
      "https://github.com/jingweno/${pname}/releases/download/v${version}/linux-amd64-${version}.tar.gz";
    sha512 =
      "28bvp4nc9fvqxwxbf98azc6v6vjsw7shhp8dlb71w6brz73gnlahl7mj4q5hkjzzsbfzrlc082rlwf17gv9x4d17cgmfns3mckaa1bi";
  };

  installPhase = ''
    install -Dm755 ccat "$out/bin/ccat"
  '';

  meta = with lib; {
    description =
      "ccat is the colorizing cat. It works similar to cat but displays content with syntax highlighting.";
    license = licenses.mit;
    homepage = "https://github.com/jingweno/ccat";
    platforms = [ "x86_64-linux" ];
  };
}
