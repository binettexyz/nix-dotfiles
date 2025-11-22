{
  callPackage,
  fetchurl,
  lib,
}:
let
  mkWallpaperGithub = callPackage (import ./mkWallpaperGithub.nix) { };
in
{
  gruvbox = mkWallpaperGithub {
    name = "gruvbox-face";
    theme = "gruvbox";
    id = "004";
    ext = "jpg";
    sha256 = "sha256-wxDlFBHGaC4yJZpb8v3Qc/WKykPtyQasYmptl1k/Nwc=";
  };

  catppuccin = mkWallpaperGithub {
    name = "Snowy-Mountain";
    ext = "jpg";
    id = "001";
    theme = "catppuccin";
    sha256 = "sha256-/KvRxonT0b0JO9502gxcgyUfRMu53tfiLChhTNq/ccY=";
  };
}
