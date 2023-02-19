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
      (nerdfonts.override {
        fonts = [
          "Iosevka"
          "FiraCode"
          "JetBrainsMono"
          "Mononoki"
          "FantasqueSansMono"
        ];
      })
    ];

    fontconfig = {
      enable = true;
      includeUserConf = true;
      cache32Bit = true;
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        serif = [ "JetBrainsMono Nerd Font Mono" ];
        sansSerif = [ "JetBrainsMono Nerd Font Mono" ];
        monospace = [
          #"FiraCode Nerd Font Mono"
          #"Iosevka Term"
          "FantasqueSansMono Nerd Font Mono"
          #"mononoki Nerd Font Mono"
        ];
      };
    };
  };

}
