{ stdenv, lib, fetchurl, jre, makeWrapper }:


stdenv.mkDerivation {
  name = "dbvisualizer-11.0.4";

  src = fetchurl {
    url =
      "https://www.dbvis.com/product_download/dbvis-11.0.4/media/dbvis_unix_11_0_4.tar.gz";
    hash = "sha256:1q1ha3vidi15nx0jvf4d81d43i6szdf4bqi3zw098vilkasiijxs";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -a . $out
    ln -sf $out/dbvis $out/bin
    wrapProgram $out/bin/dbvis --set INSTALL4J_JAVA_HOME ${jre}
  '';

  meta = {
    description = "The universal database tool";
    homepage = "https://www.dbvis.com/";
    license = lib.licenses.unfree;
  };
}
