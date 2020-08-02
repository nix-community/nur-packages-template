{ lib, python37, python3Packages, fetchFromGitHub, git, unrar, ffmpeg }:

let github = lib.importJSON ./github.json;
in python3Packages.buildPythonApplication rec {
  name = "bazarr-${github.ref}";

  src = fetchFromGitHub { inherit (github) owner repo rev sha256; };

  dontBuild = true;
  doCheck = false;

  propagatedBuildInputs = with python3Packages; [ lxml git unrar ffmpeg ];

  installPhase = ''
    mkdir -p $out/bin $out/share/bazarr/bin/Linux/x86_64/{UnRAR,ffprobe}
    cp -r bazarr libs static views ___init__.py bazarr.py $out/share/bazarr

    # morpheus65535 distributes binaries in its release.
    # The bazarr app search for thoses binaries at a predefined path. To avoid using
    # the distributed versions, we link to the one installed in the nix store.
    ln -rs ${unrar}/bin/unrar $out/share/bazarr/bin/Linux/x86_64/UnRAR/unrar
    ln -rs ${ffmpeg}/bin/ffprobe $out/share/bazarr/bin/Linux/x86_64/ffprobe/ffprobe

    cat - <<EOF > $out/bin/bazarr
    #!/bin/sh
    os.environ['GIT_PYTHON_GIT_EXECUTABLE'] = "${git}/bin/git"
    exec ${python37}/bin/python $out/share/bazarr/bazarr.py \$*
    EOF
    chmod +x $out/bin/bazarr
  '';

  meta = with lib; {
    description = "Bazarr is a companion application to Sonarr and Radarr.";
    longDescription =
      "Bazarr manages and downloads subtitles based on your requirements. You define your preferences by TV show or movie and Bazarr takes care of everything for you.";
    license = licenses.gpl3;
    homepage = "https://bazarr.media";
    platforms = platforms.all;
  };
}
