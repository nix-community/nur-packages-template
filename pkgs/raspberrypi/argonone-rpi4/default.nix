{ stdenv
, lib
, sources ? import ../../../nix/sources.nix { }
, python3
, rpi-gpio
, libffi
, lm_sensors
# , wrapPythonProgramsHook
}:

stdenv.mkDerivation {
  # Argon One Package: Fan & Power Button Control
  pname = "argonone-rpi4";
  version = "unstable-2020-09-14";
  src = sources.argonone-rpi4;
  # propagatedBuildInputs = pkgs.python3.withPackages( ps: [ ps. ]);

  nativeBuildInputs = [ python3.pkgs.wrapPython ];

  buildInputs = [ libffi lm_sensors ];

  propagatedBuildInputs = [ (python3.withPackages(ps: [ ps.smbus-cffi rpi-gpio ])) ];

  installPhase = ''
    echo "Copying ArgonOne files to Out Dir"
    mkdir -p $out/bin $out/lib/systemd/system $out/etc $out/opt/argonone
    cp argonone-config $out/bin
    cp *.py $out/opt/argonone
    cp argononed.conf $out/etc/
    cp argononed.service $out/lib/systemd/system/
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/opt/argonone/argononed.py
  '';

  postFixup = ''
    wrapPythonPrograms
    wrapPythonProgramsIn $out/opt/argonone/
  '';

  meta = with lib; {
    description = "Argon One Service and Control Scripts for Raspberry Pi 4";
    homepage = "https://github.com/Elrondo46/argonone";
    platforms = [ "aarch64-linux" ];  # Raspberry Pi 4
  };
}
