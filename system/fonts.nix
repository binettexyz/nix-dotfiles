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
      # Emoji/Icons
    font-awesome
    noto-fonts-emoji

#    nerdfonts
#    iosevka
    jetbrains-mono
    fira-code
    dejavu_fonts
      # LaTeX
    lmodern
  ];

  environment.systemPackages = with pkgs; [
    faba-mono-icons
  ];

 }
