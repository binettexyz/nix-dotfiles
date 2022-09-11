{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gruvbox-material-gtk";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "TheGreatMcPain";
    repo = pname;
    rev = "cc255d43322ad646bb35924accb0778d5e959626";
    sha256 = "sha256-1O34p9iZelqRFBloOSZkxV0Z/7Jffciptpj3fwXPHbc=";
  };

  installPhase = ''
    mkdir -p $out/share/themes/gruvbox-material-gtk
    rm -rf README.md LICENSE .github
    cp -r * $out/share/themes/gruvbox-material-gtk
  '';

  meta = with lib; {
    description = "Gruvbox-material theme for GTK based desktop environments";
    homepage = "https://github.com/TheGreatMcPain/gruvbox-material-gtk";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
