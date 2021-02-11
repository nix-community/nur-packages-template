{ lib, stdenv, mkDerivation, fetchFromGitHub, pkgconfig, cmake, ninja
, qtbase, qtx11extras, qttools, libX11, libXext, libXfixes, libXinerama, libxcb
, alsaLib, ffmpeg_3, libjack2, libv4l, libGLU, libGL, libpulseaudio
}:

let github = lib.importJSON ./github.json;
in mkDerivation rec {
  pname = "simplescreenrecorder";
  version = "0.4.3";

  src = fetchFromGitHub { inherit (github) owner repo rev sha256; };

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
  buildInputs = [
    alsaLib ffmpeg_3 libjack2
    libX11 libXext libXfixes libXinerama libxcb
    libv4l libGLU libGL libpulseaudio
    qtbase qtx11extras qttools
  ];

  meta = with lib; {
    description = "A screen recorder for Linux";
    homepage = "https://www.maartenbaert.be/simplescreenrecorder";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.goibhniu ];
  };
}
