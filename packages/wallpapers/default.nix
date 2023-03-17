{ callPackage, fetchurl, lib }:

let
  mkWallpaperImgur = callPackage (import ./mkWallpaperImgur.nix) { };
in
{
  snowy-mountain = mkWallpaperImgur {
    name = "snowy-mountain";
    id = "CinQ31C";
    sha256 = "";
  };
}
