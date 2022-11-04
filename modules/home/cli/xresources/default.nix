{ pkgs, config, lib, inputs, ... }:
with lib;

let
  cfg = config.modules.cli.xresources;
in
{
  options.modules.cli.xresources = {
  enable = mkOption {
    description = "Enable Xresources settings";
    type = types.bool;
    default = false;

  };
    theme = mkOption {
      description = "Add xresources theme";
      type = with types; nullOr (enum [ "gruvbox" "jmbi" ]);
      default = "gruvbox";
    };
  };

  config = mkIf (cfg.enable) (mkMerge [
    ({
      xresources.path = "/home/binette/.config/x11/xresources";
      xresources.properties = {
          #Xft related stuff
        "Xft.antialias" = 1;
        "Xft.hinting" = 1;
#        "Xft.dpi" = 96;
        "Xft.rgba" = "rgb";
        "Xft.lcdfilter" = "lcddefault";
          # Stuff
        "xterm.termName" = "xterm-256color";
        "xterm.vt100.locale" = false;
        "xterm.vt100.utf8" = true;
        
          # Font
        "xterm*faceName" = "FantasqueSansMono Nerd Font Mono";
        "xterm*faceSize" = 14;
        
          # Gruvbox-Material
#        "xtermcolor0" = "#171717";
#        "xtermcolor1" = "#cc241d";
#        "xtermcolor2" = "#98971a";
#        "xtermcolor3" = "#d79921";
#        "xtermcolor4" = "#458588";
#        "xtermcolor5" = "#de6809";
#        "xtermcolor6" = "#689d6a";
#        "xtermcolor7" = "#bdae93";
#        "xtermcolor8" = "#253340";
#        "xtermcolor9" = "#fb4934";
#        "xtermcolor10" ="#b8bb26";
#        "xtermcolor11" ="#fabd2f";
#        "xtermcolor12" ="#83a598";
#        "xtermcolor13" ="#fe8019";
#        "xtermcolor14" ="#8ec07c";
#        "xtermcolor15" ="#ebdbb2";
#        "xtermbackground" = "#171717";
#        "xtermforeground" = "#ebdbb2";
#        "xtermhighlightColor" = "#405055";
        
          # Backspace and escape fix
        "xterm.vt100.metaSendsEscape" = true;
        "xterm.vt100.backarrowKey" = false;
        "xtermttyModes" = "erase ^?";
        
          # Custom keybindings
#        "xtermvt100.Translations" = "#override \n\";
#        "Alt <Key>v" = "insert-selection(CLIPBOARD) \n\";
#        "Alt <Key>c" = "copy-selection(CLIPBOARD) \n\";
#        "Alt <Key>k" = "scroll-back(5,line) \n\";
#        "Alt <Key>j" = "scroll-forw(5,line)";
      };
    })

    (mkIf (cfg.theme == "gruvbox") {
      xresources.extraConfig = ''
          *.font: monospace:size=14
          ! #282828
          *background: #000000
          *foreground: #ebdbb2
          ! Black + DarkGrey
          ! #282828
          *color0:  #000000
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
  ]);


}
