{ pkgs, ... }: {

  home-manager.users.binette.services.dunst = {
    enable = true;

    settings = {
      global = {
        monitor = 0;
        follow = "keyboard";
        width = 370;
        height = 350;
        offset = "0x19";
        shrink = "yes";
        padding = 2;
        horizontal_padding = 2;
        transparency = 25;
        font = "Monospace 10";
        frame_color = "#458588";
      };

      urgency_low = {
        background = "#282828";
        foreground = "#ffffff";
        frame_color = "#689d6a";
        timeout = 3;
      };
      
      urgency_normal = {
        background = "#282828";
        foreground = "#ffffff";
        frame_color = "#458588";
        timeout = 5;
      };
      
      urgency_critical = {
        background = "#282828";
        foreground = "#ffffff";
        frame_color = "#cc241d";
        timeout = 10;
      };
    };
  };

}
