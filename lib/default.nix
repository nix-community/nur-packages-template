{ pkgs }:

with pkgs;
with pkgs.lib;

let
  fetchBintray = { pname, version, hash }:
    fetchurl {
      url =
        "https://dl.bintray.com/jeremiehuchet/nur-bin/${pname}-${version}.tar.gz";
      inherit hash;
    };
in {
  mkNodeDerivation = { pname, version, commands, hash, meta }:
    let
      installWrappers = lib.concatStrings (map (cmd: ''
        makeWrapper $(realpath $out/lib/.bin/${cmd}) $out/bin/${cmd} --argv0 $(basename ${cmd}) --set NODE_PATH $out/lib/
      '') commands);
    in stdenvNoCC.mkDerivation {
      inherit pname version;
      src = fetchBintray { inherit pname version hash; };
      buildInputs = [ nodejs-12_x makeWrapper ];
      installPhase = ''
        mkdir -p $out/bin
        cp -r . $out/lib
        ${installWrappers}
        rm -rf $out/lib/.bin
      '';
      inherit meta;
    };
}
