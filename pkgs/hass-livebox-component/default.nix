{ lib, buildHomeAssistantComponent, fetchFromGitHub, aiosysbus }:

let github = lib.importJSON ./github.json;
in buildHomeAssistantComponent {
  pname = "hass-livebox-component";
  version = github.ref;
  src = fetchFromGitHub { inherit (github) owner repo rev sha256; };
  propagatedBuildInputs = [
    aiosysbus
  ];
  meta = with lib; {
    description =
      "This a custom component for Home Assistant. The livebox integration allows you to observe and control Livebox router.";
    license = licenses.mit;
    homepage = "https://github.com/cyr-ius/hass-livebox-component";
  };
}
