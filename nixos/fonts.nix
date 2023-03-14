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
      fantasque-sans-mono
      jetbrains-mono
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
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        serif = [ "JetBrains Mono" ];
        sansSerif = [ "JetBrains Mono" ];
        monospace = [ "Fantasque Sans Mono" ];
      };
    };
  };

}
