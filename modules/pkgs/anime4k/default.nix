{ stdenvNoCC
, fetchurl
, unzip
,
}:
stdenvNoCC.mkDerivation rec {
  pname = "Anime4k";
  version = "4.0.1";

  src = fetchurl {
    url = "https://github.com/bloc97/Anime4K/releases/download/v${version}/Anime4K_v4.0.zip";
    sha256 = "E5zSgghkV8Wtx5yve3W4uCUJHXHJtUlYwYdF/qYtftc=";
  };

  buildInputs = [ unzip ];

  phases = [ "unpackPhase" "installPhase" ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir $out
    cp *.glsl $out
  '';

  meta = {
    description = "A High-Quality Real Time Upscaler for Anime Video";
  };
}
