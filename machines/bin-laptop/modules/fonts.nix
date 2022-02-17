{ config, pkgs, ... }: {

    # fonts
  fonts.fonts = with pkgs; [
    font-awesome
    jetbrains-mono
    fira-code
    dejavu_fonts
    lmodern
  ];

 }
