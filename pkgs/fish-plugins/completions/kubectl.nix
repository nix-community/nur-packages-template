{ lib, sources, runCommand, packagePlugin }:
with lib;
let
  mySrc = sources.fish-kubectl-completions;

  name = "fish-kubectl-completions";
  version = mySrc.version;

  src = runCommand "fish-completion-${name}-${version}-src" {
    src = "${mySrc}/completions/kubectl.fish";
  } ''
    mkdir -p $out/completions
    cp $src $_/${name}.fish
  '';
in
packagePlugin {
  inherit src;
  name = "${name}-completion-${version}";
  meta = {
    inherit (mySrc) description homepage;
    license = licenses.mit;
  };
}
