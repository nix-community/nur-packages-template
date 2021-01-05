{ stdenv, pkgs, fetchurl, pkgconfig, cmake, ninja
}:

stdenv.mkDerivation rec {
  pname = "simplescreenrecorder";
  version = "0.3.11";

  src = fetchurl {
    url = "https://github.com/MaartenBaert/ssr/archive/${version}.tar.gz";
    sha256 = "0l6irdadqpajvv0dj3ngs1231n559l0y1pykhs2h7526qm4w7xal";
  };

  cmakeFlags = [ "-DWITH_QT5=TRUE" ];

  patches = [ ./fix-paths.patch ];

  postPatch = ''
    for i in scripts/ssr-glinject src/AV/Input/GLInjectInput.cpp; do
      substituteInPlace $i \
        --subst-var out \
        --subst-var-by sh ${stdenv.shell}
    done
  '';

  nativeBuildInputs = [ pkgconfig cmake ninja ];
  buildInputs = with pkgs; [
    alsaLib ffmpeg_3 libjack2
    xorg.libX11 xorg.libXext xorg.libXfixes
    libGLU libGL libpulseaudio
    qt5.qtbase qt5.qtx11extras
  ];

  meta = with stdenv.lib; {
    description = "A screen recorder for Linux";
    homepage = "https://www.maartenbaert.be/simplescreenrecorder";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.goibhniu ];
  };
}
