{ stdenv, fetchurl, pkgs, makeDesktopItem, makeWrapper, lib, sources, ... }:
with lib;
let
  source = sources.winbox-bin;
  description = "Winbox is a small utility that allows administration of MikroTik RouterOS using a fast and simple GUI";
  meta = with stdenv.lib; {
    inherit description;
    longDescription = description;
    homepage = https://mikrotik.com;
    license = {
      fullName = "MIKROTIKLS MIKROTIK SOFTWARE END-USER LICENCE AGREEMENT";
      url = https://mikrotik.com/downloadterms.html;
      free = false;
    };
    maintainers = [];
    platforms = platforms.all;
  };
  desktopItem = makeDesktopItem {
    name = "WinBox";
    exec = "winbox";
    comment = meta.description;
    desktopName = "Winbox";
    categories = "Application;Development;";
    genericName = "Winbox";
  };
in
stdenv.mkDerivation rec {
  inherit meta;
  name = "winbox-bin-${version}";
  version = source.version;
  src = source;
  preferLocalBuild = true;
  nativeBuildInputs = with pkgs; [ makeWrapper ];
  buildInputs = with pkgs; [ wine ];

  phases = [ "unpackPhase" "buildPhase" ];

  unpackPhase = ''
    mkdir -p ${name}
    cp $src ${name}/winbox.exe
  '';

  buildPhase = ''
    mkdir -p $out/bin
    cp -r ${name}/winbox.exe $out/bin/
    makeWrapper ${pkgs.wine}/bin/wine $out/bin/winbox \
      --run "export WINEPREFIX=\"\''${XDG_DATA_HOME:-\$HOME/.local/share}/winbox\"" \
      --add-flags $out/bin/winbox.exe

    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications
  '';
}
