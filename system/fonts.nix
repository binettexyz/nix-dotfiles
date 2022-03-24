{ config, pkgs, ... }: {

  fonts.fontDir.enable = true;
  fonts.fontconfig = {
    enable = true;
    includeUserConf = true;
    cache32Bit = true;
  };
  fonts.fontconfig.defaultFonts = {
    emoji = [ "Noto Color Emoji" ];
    monospace = [ "Fira Code" ];
  };

  fonts.fonts = with pkgs; [
    font-awesome
    noto-fonts-emoji
    jetbrains-mono
    fira-code
    dejavu_fonts
      # LaTeX
    lmodern
  ];

 }
