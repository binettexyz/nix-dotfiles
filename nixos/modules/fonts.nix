{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.modules.system.customFonts.enable;
in {

  options.modules.system.customFonts.enable = mkEnableOption {
    description = "Enable custom fonts";
    default = false;
  };

  config = lib.mkIf config.modules.system.customFonts.enable {
    environment.systemPackages = with pkgs; [ faba-mono-icons ];

    fonts = {
      fontDir.enable = true;
  
      enableDefaultPackages = true;
      packages = with pkgs; [
        lmodern
        font-awesome
        noto-fonts-emoji
        material-design-icons
        (nerdfonts.override {
          fonts = [ "FantasqueSansMono" "JetBrainsMono" ];
        })
      ];
  
      fontconfig = {
        enable = true;
        includeUserConf = true;
        cache32Bit = true;
        defaultFonts = {
          emoji = [ "Noto Color Emoji" ];
          serif = [ "JetBrainsMono Nerd Font" ];
          sansSerif = [ "JetBrainsMono Nerd Font" ];
          monospace = [ "FantasqueSansMono Nerd Font mono" ];
        };
      };
    };
  };

}
