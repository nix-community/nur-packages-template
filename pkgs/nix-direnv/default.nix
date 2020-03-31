{ stdenvNoCC, fetchFromGitHub }:

with stdenvNoCC;

mkDerivation rec {
  pname = "nix-direnv";
  version = "ea98d41";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = version;
    sha512 =
      "163pj9j7nlhfrsifijnsy6daf4sb528wm464kd43nc5jhkj62gj8m99zk7dxklayamj0mbk6zqn9j2xhx6sqd3fw3yvz67l939j1v49";
  };

  installPhase = ''
    install -Dm644 direnvrc "$out/share/nix-direnv/direnvrc"
  '';

  meta = with lib; {
    description = "A fast, persistent use_nix implementation for direnv";
    license = licenses.mit;
    homepage = "https://github.com/nix-community/nix-direnv";
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}
