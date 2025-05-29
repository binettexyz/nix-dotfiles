{config, lib, ...}:
let
  cfg = config.modules.hm.theme.colorScheme;
in {
  options.modules.hm.theme.colorScheme = lib.mkOption {
    description = "ColorScheme Selection";
    type = with lib.types;
    nullOr (enum [
      "gruvbox"
      "catppuccin"
      "jmbi"
    ]);
    default = "gruvbox-material";
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg == "gruvbox") {
      colorScheme = {
        name = "Gruvbox Material";
        description = "Gruvbox Material Dark";
        author = "https://github.com/sainnhe/gruvbox-material";
        palette = rec {
          # Background Pane
          bg0 = "#141617";

          # Secondary panes
          bg1 = "#1d2021";
          bg2 = "#282828";

          # Surface Elements
          surface0 = "#282828";
          surface1 = "#32302f";
          surface2 = "#504945";

          # Window Colors
          activeBorder = blue;
          inactiveBorder = green;

          # Foreground Colors
          fg0 = "#d4be98";
          fg1 = "#ddc7a1";
          fg2 = "#bdae93";

          # Regular Colors 0-7
          black = "#32302f";
          red = "#ea6962";
          green = "#a9b665";
          yellow = "#d8a657";
          blue = "#7daea3";
          magenta = "#d3869b";
          cyan = "#89b482";
          white = "#d4be98";

          # Bold Colors 8-15
          blackBright = "#928374";
          redBright = "#ea6962";
          greenBright = "#a9b665";
          yellowBright = "#d8a657";
          blueBright = "#7daea3";
          magentaBright = "#d3869b";
          cyanBright = "#89b482";
          whiteBright = "#d4be98";
        };
      };
    })
    (lib.mkIf (cfg == "gruvbit") {
    })
    (lib.mkIf (cfg == "jmbi") {
      colorScheme = {
        name = "JMBI";
        author = "terminal.sexy";
        palette = rec {
          # Background Pane
          bg0 = "#1e1e1e";

          # Secondary Panes
          bg1 = "#2a2a2a";
          bg2 = "#333333";

          # Surface Elements
          surface0 = "#44403c";
          surface1 = "#5a504a";
          surface2 = "#6c5a4e";

          # Window Colors
          activeBorder = black;
          inactiveBorder = red;

          # Foreground Colors
          fg0 = "#e6dedb";
          fg1 = "#d1c6c3";
          fg2 = "#bcb0ad";
          
          # Regular Colors 0-7
          black = "#485348";
          red = "#8f423c";
          green = "#bbbb88";
          yellow = "#f9d25b";
          blue = "#e0ba69";
          magenta = "#709289";
          cyan = "#d13516";
          white = "#efe2e0";

          # Bold Colors 8-15
          blackBright = "#6b726a";
          redBright = "#eeaa88";
          greenBright = "#ccc68d";
          yellowBright = "#eedd99";
          blueBright = "#c9b957";
          magentaBright = "#ffcbab";
          cyanBright = "#c25431";
          whiteBright = "#f9f1ed";
        };
      };
    })
    (lib.mkIf (cfg == "catppuccin") {
      colorScheme = {
        name = "Catppuccin - Mocha";
        author = "https://github.com/catppuccin/catppuccin/blob/main/docs/style-guide.md";
        palette = rec {
          # Background Pane
          bg0 = "#11111b";

          # Secondary panes
          bg1 = "#181825";
          bg2 = "#1e1e2e";

          # Surface Elements
          surface0 = "#313244";
          surface1 = "#45475a";
          surface2 = "#585b70";

          # Window Colors
          activeBorder = peach;
          inactiveBorder = flamingo;

          # Foreground Colors
          fg0 = "#cdd6f4";
          fg1 = "#bac2de";
          fg2 = "#a6adc8";

          # Regular Colors 0-7
          black = "#45475a";
          red = "#f38ba8";
          green = "#a6e3a1";
          yellow = "#f9e2af";
          blue = "#89b4fa";
          magenta = "#f5c2e7";
          cyan = "#94e2d5";
          white = "#a6adc8";

          # Bold Colors 8-15
          blackBright = "#585b70";
          redBright = "#f38ba8";
          greenBright = "#a6e3a1";
          yellowBright = "#f9e2af";
          blueBright = "#89b4fa";
          magentaBright = "#f5c2e7";
          cyanBright = "#94e2d5";
          whiteBright = "#bac2de";

          # Extended Colors 16-22
          peach = "#fab387";
          rosewater = "#f5e0dc";
          flamingo = "#f2cdcd";
          mauve = "#cba6f7";
          maroon = "#eba0ac";
          sky = "#89dceb";
          lavender = "#b4befe";
        };
      };
    })
  ];
}
