{ pkgs, config, lib, inputs, ... }:
with lib;

let
  cfg = config.modules.cli.xresources;
in
{
  options.modules.cli.xresources = mkOption {
      description = "Add xresources theme";
      type = types.enum [ "gruvbox" "jmbi" ];
      default = "gruvbox";
  };

  config = mkMerge [
    (mkIf (cfg == "gruvbox") {
      xresources.path = "/home/binette/.config/x11/xresources";
      xresources.extraConfig = ''
        *.font: monospace:size=14
        *background: #282828
        *foreground: #ebdbb2
        ! Black + DarkGrey
        *color0:  #282828
        *color8:  #928374
        ! DarkRed + Red
        *color1:  #cc241d
        *color9:  #fb4934
        ! DarkGreen + Green
        *color2:  #98971a
        *color10: #b8bb26
        ! DarkYellow + Yellow
        *color3:  #d79921
        *color11: #fabd2f
        ! DarkBlue + Blue
        *color4:  #458588
        *color12: #83a598
        ! DarkMagenta + Magenta
        *color5:  #b16286
        *color13: #d3869b
        ! DarkCyan + Cyan
        *color6:  #689d6a
        *color14: #8ec07c
        ! LightGrey + White
        *color7:  #a89984
        *color15: #ebdbb2
      '';
    })
    (mkIf (cfg == "jmbi") {
      xresources.path = "/home/binette/.config/x11/xresources";
      xresources.extraConfig = ''
        *.font: monospace:size=13
        *.background:   #000000
        *.foreground:   #ffffff
          ! Black + DarkGrey
        *.color0:       #5a7260
        *.color8:       #8da691
          ! DarkRed + Red
        *.color1:       #8f423c
        *.color9:       #eeaa88
          ! DarkGreen + Green
        *.color2:       #bbbb88
        *.color10:      #ccc68d
          ! DarkYellow + Yellow
        *.color3:       #f9d25b
        *.color11:      #eedd99
          ! DarkBlue + Blue
        *.color4:       #e0ba69
        *.color12:      #c9b957
          ! DarkMagenta + Magenta
        *.color5:       #709289
        *.color13:      #ffcbab
          ! DarkCyan + Cyan
        *.color6:       #d13516
        *.color14:      #c25431
          ! LightGrey + White
        *.color7:       #efe2e0
        *.color15:      #f9f1ed
      '';
    })
  ];


}
