{ sources ? import ../../../nix/sources.nix {}
, buildPythonPackage
, lib
, nose
}:

buildPythonPackage rec {
  pname = "smbus2";
  version = "0.4.0";

  src = sources.smbus2;

  propagatedBuildInputs = [ ];

  checkInputs = [ nose ];
  pythonImportsCheck = [ "smbus2" ];
  checkPhase = "nosetests";

  meta = with lib; {
    description = "Yet another python color library";
    homepage = "https://smbus2.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
