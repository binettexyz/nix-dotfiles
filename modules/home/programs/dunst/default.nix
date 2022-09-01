{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.programs.dunst;
in
{
  options.modules.programs.dunst = {
    enable = mkOption {
      description = "Enable dunst package";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    services.dunst = {
      enable = true;

      settings = {
          # Allow a small subset of html markup:
          #   <b>bold</b>
          #   <i>italic</i>
          #   <s>strikethrough</s>
          #   <u>underline</u>
          #
          # For a complete reference see
          # <http://developer.gnome.org/pango/stable/PangoMarkupFormat.html>.
          # If markup is not allowed, those tags will be stripped out of the
          # message.
        markup = "full";
          # The format of the message.  Possible variables are:
          #   %a  appname
          #   %s  summary
          #   %b  body
          #   %i  iconname (including its path)
          #   %I  iconname (without its path)
          #   %p  progress value if set ([  0%] to [100%]) or nothing
          # Markup is allowed
        format = "%s\n%b";
          # Sort messages by urgency.
        sort = "no";
          # Show how many messages are currently hidden (because of geometry).
        indicate_hidden = "yes";

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
  };

}
