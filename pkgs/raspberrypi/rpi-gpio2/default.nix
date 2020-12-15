{ lib
, buildPythonPackage
, sources ? import ../../../nix/sources.nix { }
, libgpiod
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "rpi-gpio2";
  version = "0.3.0a3";

  src = sources.rpi-gpio2;

  propagatedBuildInputs = [ libgpiod ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "rpi.gpio" ];

  meta = with lib; {
    description = "Compatibility layer between RPi.GPIO syntax and libgpiod semantics";
    homepage = "https://github.com/underground-software/RPi.GPIO2";
    license = licenses.gpl3Plus;
    platforms = [ "aarch64-linux" ];
  };
}
