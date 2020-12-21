{ sources ? import ../../../nix/sources.nix {}
, lib
, buildPythonPackage
, colorzero
, withPigpio ? true, pigpio-py
, withRpiGpio ? false, rpi-gpio
, withRpio ? false, rpio ? null
, pytestCheckHook
, mock
}:

buildPythonPackage rec {
  pname = "gpiozero";
  version = "1.5.1";

  src = sources.gpiozero;

  propagatedBuildInputs = [ colorzero ]
    ++ lib.optionals (withPigpio) [ pigpio-py ]
    ++ lib.optionals (withRpiGpio) [ rpi-gpio ]
    ++ lib.optionals (withRpio) [ rpio ] ;

  checkInputs = [ pytestCheckHook mock ];
  pythonImportsCheck = [ "gpiozero" ];

  meta = with lib; {
    description = "A simple interface to GPIO devices with Raspberry Pi";
    homepage = "https://gpiozero.readthedocs.io/en/stable/";
    license = licenses.bsd3;
    maintainers = [ maintainers.drewrisinger ];
  };
}
