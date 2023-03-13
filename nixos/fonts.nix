{ config, pkgs, ... }: {

  environment.systemPackages = with pkgs; [ faba-mono-icons ];

  fonts = {
    enableDefaultFonts = true;
    fontDir.enable = true;

    fonts = with pkgs; [
      lmodern
      font-awesome
      noto-fonts-emoji
      material-design-icons
      material-icons
      fira-code
        #FIXME: Nerd fonts make icons small and cant be bigger if increasing icon size. 
#      (nerdfonts.override {
#        fonts = [
#          "Iosevka"
#          "FiraCode"
#          "JetBrainsMono"
#          "Mononoki"
#          "FantasqueSansMono"
#        ];
#      })
    ];

    fontconfig = {
      enable = true;
      includeUserConf = true;
      cache32Bit = true;
        #TODO: Find better font instead of nerdfonts.
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
#        serif = [ "JetBrainsMono Nerd Font Mono" ];
#        sansSerif = [ "JetBrainsMono Nerd Font Mono" ];
        monospace = [
          "FiraCode"
          #"FiraCode Nerd Font Mono"
          #"Iosevka Term"
          #"FantasqueSansMono Nerd Font Mono"
          #"mononoki Nerd Font Mono"
        ];
      };
    };
  };

}
