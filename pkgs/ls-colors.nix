{ lib, sources, stdenv }:
with lib;
let
  src = sources.LS_COLORS;
in
stdenv.mkDerivation rec {
  inherit src;
  name = "trapd00r-ls-colors-${version}";
  version = src.rev;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out
    cp -r LS_COLORS $out/LS_COLORS
  '';
  meta = {
    inherit (src) description homepage;
    license = licenses.artistic1;
    platform = platforms.all;
  };
}
