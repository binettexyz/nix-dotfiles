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
    id = "002";
    sha256 = "sha256-VUxP06aCKh365lzaQ17Sug8rZ5oVXRmoAh7ifwdjY6w=";
  };

  catppuccin = mkWallpaperGithub {
    name = "Snowy-Mountain";
    ext = "jpg";
    id = "001";
    theme = "catppuccin";
    sha256 = "sha256-/KvRxonT0b0JO9502gxcgyUfRMu53tfiLChhTNq/ccY=";
  };
}
