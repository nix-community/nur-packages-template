{ pkgs }:

let
  upstreamMaintainers = pkgs.lib.maintainers;
in
with pkgs.lib; {
  # Add your library functions here
  #
  # hexint = x: hexvals.${toLower x};
  maintainers = upstreamMaintainers // import ../maintainers.nix;
}
