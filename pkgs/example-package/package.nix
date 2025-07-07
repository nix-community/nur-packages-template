{ stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "example-package";
  version = "1.0";

  src = ./.;

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    echo "echo \"Hello World!\"" > example
    chmod +x example

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 example $out/bin

    runHook postInstall
  '';
}
