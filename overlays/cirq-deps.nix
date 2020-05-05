self: super:

rec {
  # TODO: expand to python37, py38, py3
  # TODO: guard against regression. Condition: if oldAttrs.version < version || (if does not exist py-super.name)

  # overlay the most-updated version of these python packages over the default package set.
  # Needed to allow building on e.g. nixpkgs-19.09
  python3 = super.python3.override {
    packageOverrides = py-self: py-super:
    let
      # Check if the py-super version is newer and use that if so.
      overrideSuperVersionIfNewer = superPyPackage: localPyPackage:
        if super.lib.versionAtLeast superPyPackage.version localPyPackage.version then
          superPyPackage
        else
          localPyPackage;
    in
    {
      google_api_core = overrideSuperVersionIfNewer py-super.google_api_core (py-super.callPackage ../pkgs/python-modules/google_api_core { });
      googleapis_common_protos = overrideSuperVersionIfNewer py-super.googleapis_common_protos (py-super.callPackage ../pkgs/python-modules/googleapis_common_protos { });
    };
  };

  python3Packages = python3.pkgs;
}