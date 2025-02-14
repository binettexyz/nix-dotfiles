{ pkgs, config, lib, ... }:
with lib;

{
    home.packages = with pkgs; [ libnotify ];
    services.dunst = {
      enable = true;

      settings = {
        global = {
          monitor = 0;
          follow = "keyboard";
          width = 370;
          height = 350;
          offset = "0x19";
          shrink = "no";
          padding = 2;
          horizontal_padding = 2;
          transparency = 15;
          frame_color = "#458588";

          idle_threshold = 120;
          font = "sans-serif 13";
          line_height = 4;

            # Define a color for the separator.
            # possible values are:
            #  * auto: dunst tries to find a color fitting to the background;
            #  * foreground: use the same color as the foreground;
            #  * frame: use the same color as the frame;
            #  * anything else will be interpreted as a X color.
          separator_color = "auto";

            # Sort messages by urgency.
          sort = "no";

            # Allow a small subset of html markup:
            #   <b>bold</b>
            #   <i>italic</i>
            #   <s>strikethrough</s>
            #   <u>underline</u>
            #
            # The format of the message.  Possible variables are:
            #   %a  appname
            #   %s  summary
            #   %b  body
            #   %i  iconname (including its path)
            #   %I  iconname (without its path)
            #   %p  progress value if set ([  0%] to [100%]) or nothing
            # Markup is allowed
          markup = "full";
          format = "<b>%s</b>\n%b";

          alignment = "left";
          show_age_threshold = 60;
          word_wrap = "yes";
          ellipsize = "middle";
          ignore_newline = "no";
          stack_duplicates = true;
          hide_duplicate_count = true;
          show_indicators = "yes";
          icon_position = "left";
          max_icon_size = "40";
          sticky_history = "yes";
          history_length = 20;
          dmenu = "${pkgs.dmenu} -p dunst:";
          browser = "librewolf -new-tab";

            # Always run rule-defined scripts, even if the notification is suppressed
          always_run_script = true;


          title = "Dunst";
          class = "Dunst";
          startup_notification = false;
          force_xinerama = false;
        };
          
        experimental = {
          per_monitor_dpi = false;
        };

        shortcuts = {
            # [modifier+][modifier+]key
            # "ctrl", "mod1" (the alt-key), "mod2",
            # "mod3" and "mod4" (windows-key).

            # Close notification.
          close = "ctrl+shift+space";

            # Close all notifications.
          close_all = "ctrl+shift+space";

            # Redisplay last message(s).
            # On the US keyboard layout "grave" is normally above TAB and left
            # of "1".
          history = "ctrl+grave";
        };
  
        urgency_low = {
          background = "#282828";
          foreground = "#ffffff";
          frame_color = "#689d6a";
          timeout = 5;
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
          timeout = 0;
        };
      };
    };

}
