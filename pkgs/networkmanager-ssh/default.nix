{ stdenv
, lib
, pkgs
, fetchFromGitHub
, intltool
, pkgconfig
, autoreconfHook
, networkmanager
, gtk3
, glib
, gnome3
, libnma ?
  # libnma is available in pkgs.libnma in nixos unstable
  # but in nixos stable it is in pkgs.networkmanagerapplet
  if builtins.hasAttr "libnma" pkgs then
    pkgs.libnma
  else
    pkgs.networkmanagerapplet
, libsecret
, substituteAll
, openssh
, sshpass
, kmod
}:

stdenv.mkDerivation rec {
  pname = "NetworkManager-ssh";
  version = "1.2.11";

  src = fetchFromGitHub {
    owner = "danfruehauf";
    repo = pname;
    rev = version;
    hash =
      "sha512:033jhi5f537y0p13125jlw80fsma1kp4csfq3swrv6vjv3aldizbvrfvw7iwrkf3r274zy20p3byi1b2cwp5amdkark18z8l9s538qj";
  };

  nativeBuildInputs = [ intltool pkgconfig autoreconfHook ];
  buildInputs = [ networkmanager libnma gtk3 glib libsecret ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit kmod openssh sshpass;
    })
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "networkmanager-ssh";
    };
  };

  meta = with lib; {
    description = "SSH VPN integration for NetworkManager";
    license = licenses.gpl2;
    homepage = "https://github.com/danfruehauf/NetworkManager-ssh";
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
