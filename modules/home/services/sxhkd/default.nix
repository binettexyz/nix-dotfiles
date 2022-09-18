{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.services.sxhkd;
in
{
  options.modules.services.sxhkd = {
    enable = mkOption {
      description = "Enable flameshot service";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    services.sxhkd = {
      enable = true;

      keybindings = {

        /* ---SUPER + KEY--- */

          # make sxhkd reload its configuration files:
        "super + Escape" = "pkill -USR1 -x sxhkd; notify-send 'sxhkd' 'Service restarted'";
          # terminal emulator
        "super + Return" = "$TERMINAL";

        /* ---SUPER + ALT + KEY--- */

          # browser
        "super + alt + b" = "brave";
          # Chat services
        "super + alt + r" = "ripcord";
        "super + alt + d" = "discordcanary";
          # file manager
        "super + alt + f" = "lfrun";
          # rss viewer
        "super + alt + n" = "st -e newsboat";

        /* ---SUPER + SHIFT + KEY--- */

          # System fonctions
        "super + Q" = "sysact";
          # tmux
        "super + shift + Return" = "$TERMINAL -e 'tmux attach || tmux'";


        /* ---SUPER + CONTROL + KEY--- */


        /* ---CONTROL + ALT + KEY--- */

          # Screenshot tools
        "control + alt + f" = "flameshot gui";
          # password
        "control + alt + p" = "dmenu-passmenu";
          # clipboard manager
        "{control + alt + c, Menu}" = "clipboard";

        /* ---SHIFT + KEY--- */

          # fullscreen screenshot
        "shift + Print" = "screenshot";

        /* ---KEY--- */

          # screenshot script
        "Print" = "maimpick";
          # volume
        "XF86Audio{Mute,RaiseVolume,LowerVolume}" = "~/.config/sxhkd/action/volume.sh {mute,up,down}";
          # mic
        "X86AudioMicMute" = "pamixer --source 45 -t";
          # screen brighness
        "XF86MonBrightness{Up,Down}" = "~/.config/sxhkd/action/brightness.sh {up,down}";
          # dmenu display
        "XF86XK_Display" = "dmenu-display";
      };
    };

  home.file.".config/sxhkd/action".source = ./action;

  };

}

