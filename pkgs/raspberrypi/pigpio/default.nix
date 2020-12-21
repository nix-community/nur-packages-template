{ sources ? import ../../../nix/sources.nix {}
, stdenv
, lib
, cmake
}:

# C libraries & daemon for pigpio
stdenv.mkDerivation {
  pname = "pigpio";
  version = "78";

  src = sources.pigpio;

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A C library for the Raspberry Pi which allows control of the General Purpose Input Outputs (GPIO)";
    homepage = "http://abyz.me.uk/rpi/pigpio/";
    license = licenses.unlicense;
    platforms = [ "aarch64-linux" "armv7l-linux" ]; # targeted at Raspberry Pi ONLY
    maintainers = [ maintainers.drewrisinger ];
  };
}
