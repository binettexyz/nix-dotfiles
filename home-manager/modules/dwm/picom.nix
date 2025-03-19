{ pkgs, config, lib, super, ... }:
with lib;

let
  cfg = super.services.xserver.windowManager.dwm;
in {

  services.picom = lib.mkIf cfg.enable {
      # Enabled client-side shadows on windows. 
    enable = true;
    backend = "glx";

    /* Opacity */
    activeOpacity = 0.7; # (0.0 - 1.0 )
    inactiveOpacity = 0.6; # (0.0 - 1.0 )
    opacityRules = [
      "100:class_g = 'Dunst'"
      "100:class_g = 'dmenu'"
      "100:class_g = 'nsxiv'"
      "100:class_g = 'qutebrowser'"
      "100:class_g = 'dwm'"
      "100:class_g = 'St'"
      "100:class_g = 'librewolf'"
      "100:class_g = 'Brave-browser'"
      "100:class_g = 'mpv'"
      "100:class_g = 'Minecraft*'"
      "100:class_g = 'Jellyfin Media Player'"
      "100:class_g = 'discord'"
      "100:class_g = 'tidal-hifi'"
    ];

    /* Fading */
    fade = true;
      # The time between steps in fade step, in milliseconds.
    fadeDelta = 5; # (> 0, defaults to 10)
      # Opacity change between steps while fading in. (in) (out)
    fadeSteps = [ (0.03) (0.03) ]; # (0.01 - 1.0, defaults to [ (0.028) (0.03) ])
    fadeExclude = [
      "class_g = 'St'"
    ];

    /* Shadow */
    shadow = false;
      # The opacity of shadows.
    shadowOpacity = 0.75; # (0.0 - 1.0, defaults to 0.75)
      # Offset for shadows, in pixels. (left) (right)
    shadowOffsets = [ (-7) (-7) ]; # (defaults to -15)
      # Specify a list of conditions of windows that should have no shadow.
    shadowExclude = [
    ];

    vSync = true; # Reduce screen tearing

    /* Extra settings */
    settings = {
      refresh-rate = 0;
      /* Shadow */
        # The blur radius for shadows, in pixels.
      shadow-radius = 7; # (defaults to 12)

      /* Corners */
        # with https://github.com/ibhagwan/picom
        # Sets the radius of rounded window corners. 0 to disable.
      corner-radius = 10;
        # enable rounded border
      round-borders = 1;
        # Exclude conditions for rounded corners.
      detect-rounded-corners = true;
      rounded-corners-exclude = [
        "class_g = 'dwm'"
        #"class_g = 'dmenu'"
      ];

      /* Focus */

      /* Fading */
        # Specify a list of conditions of windows that should not be faded.
      fade-exclude = [
        #"class_g = 'St'"
      ];

      /* Blur */
      blur = {
        method = "dual_kawase";
        strength = 7;
          # Use fixed blur strength rather than adjusting according to window opacity
        background-fixed = true;
        blur-background-exclude = [
          "class_g = 'librewolf'"
          "class_g = 'mpv'"
          "class_g = 'Brave-browser'"
          "class_g = 'Minecraft*'"
          "class_g = 'Jellyfin Media Player'"
          "class_g = 'discord'"
        ];
      };

      /* Wintype */
      wintypes = {
        normal = { fade = false; shadow = false; };
        notification = { fade = true; shadow = true; };
        popup_menu = { opacity = 0.8; };
        dropdown_menu = { opacity = 0.8; };
      };
    };
  };

}
