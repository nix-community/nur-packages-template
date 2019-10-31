{ lib, pkgs, sources, ... }:
with lib;
let
  src = sources.kustomize1;
in
pkgs.buildGoPackage rec {
  inherit src;
  name = "kustomize-${version}";
  version = src.version;
  goPackagePath = "sigs.k8s.io/kustomize";

  buildFlagsArray = let
    t = "${goPackagePath}/pkg/commands";
  in
    ''
      -ldflags=
        -s -X sigs.k8s.io/kustomize/pkg/commands/misc.kustomizeVersion=${version}
           -X sigs.k8s.io/kustomize/pkg/commands/misc.gitCommit=${src.rev}
    '';

  meta = {
    inherit (src) description homepage;
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
