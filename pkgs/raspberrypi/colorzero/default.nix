{ sources ? import ../../../nix/sources.nix {}
, buildPythonPackage
, lib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "colorzero";
  version = "1.1";

  src = sources.colorzero;

  propagatedBuildInputs = [];

  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "colorzero" ];

  meta = with lib; {
    description = "Yet another python color library";
    homepage = "https://colorzero.readthedocs.io/en/latest/";
    license = licenses.bsd3;
    maintainers = [ maintainers.drewrisinger ];
  };
}
