{
  flake.modules.homeManager.hyprPackages =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.pamixer
        pkgs.pulsemixer
        pkgs.wtype # Simulate keyboard inputs
        pkgs.zenity # Prompt
        pkgs.wlr-randr
        pkgs.vimiv-qt
        pkgs.waylock
        pkgs.wofi
        pkgs.mupdf
        pkgs.udiskie
        pkgs.zathura
      ];

    };
}
