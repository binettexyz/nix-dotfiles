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
    ]);
    default = "gruvbox-material";
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg == "gruvbox") {
      colorScheme = {
        name = "Gruvbox Material";
        description = "Gruvbox Material Dark";
        author = "https://github.com/sainnhe/gruvbox-material";
        palette = {
          background = "#141617";
          foreground = "#d4be98";
          cursorColor = "#ddc7a1";
          black = "#1d2021";
          red = "#ea6962";
          green = "#a9b665";
          yellow = "#d8a657";
          blue = "#7daea3";
          magenta = "#d3869b";
          cyan = "#89b482";
          white = "#d4be98";
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
    (lib.mkIf (cfg == "catppuccin") {
      colorScheme = {
        name = "Catppuccin - Mocha";
        author = "https://github.com/catppuccin/xresources";
        palette = {
          background = "#181825";
          foreground = "#cdd6f4";
          cursorColor = "#cdd6f4";
          black = "#54575a";
          red = "#f38ba8";
          green = "#a6e3a1";
          yellow = "#f9e2af";
          blue = "#89b4fa";
          magenta = "#f5c2e7";
          cyan = "#94e2d5";
          white = "#bac2de";
          blackBright = "#585b70";
          redBright = "#f38ba8";
          greenBright = "#a6e3a1";
          yellowBright = "#f9e2af";
          blueBright = "#89b4fa";
          magentaBright = "#f5c2e7";
          cyanBright = "#94e2d5";
          whiteBright = "#a6adc8";
        };
      };
    })
  ];
}
