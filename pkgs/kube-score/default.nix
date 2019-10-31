{ lib, pkgs, sources, ... }:
with lib;
let
  src = sources.kube-score;
in
pkgs.buildGoPackage rec {
  inherit src;
  name = "kube-score-${version}";
  version = src.version;
  goPackagePath = "github.com/zegl/kube-score";
  goDeps = ./deps.nix;

  buildFlagsArray = ''
    -ldflags=
      -s -w -X main.version=${version}
            -X main.commit=${src.rev}
  '';

  meta = {
    inherit (src) description homepage;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
