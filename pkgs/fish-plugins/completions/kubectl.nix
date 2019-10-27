{ sources, runCommand, packagePlugin }:

let
  name = "kubectl";
  version = sources.fish-kubectl-completions.version;

  src = runCommand "fish-completion-${name}-${version}-src" {
    src = "${sources.fish-kubectl-completions}/completions/kubectl.fish";
  } ''
    mkdir -p $out/completions
    cp $src $_/${name}.fish
  '';
in
packagePlugin {
  inherit src;
  name = "${name}-completion-${version}";
}
