{ stdenvNoCC, fetchurl, unzip, }:

stdenvNoCC.mkDerivation rec {
  pname = "freedoom";
  version = "0.13.0";

  src = fetchurl {
    url = "https://github.com/freedoom/freedoom/releases/download/v0.13.0/freedoom-0.13.0.zip";
    sha256 = "sha256-P5smTz485QO0+39r3LH0Gdk8e1RvTfPodN2Hjbloj1k=";
  };

  buildInputs = [ unzip ];

  phases = [ "unpackPhase" "installPhase" ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir $out
    cp freedoom-0.13.0/*.wad $out
  '';

  meta = {
    description = "Freedoom is an entirely free software game based on the Doom engine.";
  };

}
