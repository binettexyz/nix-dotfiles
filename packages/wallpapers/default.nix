{ callPackage, fetchurl, lib }:

let
  mkWallpaperImgur = callPackage (import ./mkWallpaperImgur.nix) { };
in
{
  snowy-mountain = mkWallpaperImgur {
    name = "snowy-mountain";
    id = "CinQ31C";
    sha256 = "sha256-lA9C98C+K+lCjJC51PfdYCnNAFXC5RfJfBXaebEdYUc=";
  };
}
