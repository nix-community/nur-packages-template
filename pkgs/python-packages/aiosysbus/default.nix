{ lib
, python3Packages
, fetchFromGitHub
}:

let github = lib.importJSON ./github.json;
in python3Packages.buildPythonPackage {
  pname = "aiosysbus";
  version = github.ref;
  format = "setuptools";

  src = fetchFromGitHub { inherit (github) owner repo rev sha256; };

  patchPhase = ''
    sed -i 's/replace_by_workflow/${github.ref}/g' setup.py
  '';

  outputs = [ "out" ];

  buildInputs = [
    python3Packages.requests
  ];

  sphinxRoot = "doc/src";

  pythonImportsCheck = [
    "aiosysbus"
  ];

  meta = with lib; {
    description = "Manage your Livebox in Python";
    homepage = "https://github.com/cyr-ius/aiosysbus";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ ];
  };
}
