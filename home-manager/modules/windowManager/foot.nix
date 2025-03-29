{ pkgs, config, lib, super, ... }: {

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "monospace:size=10";
      };
      url = {
        launch = "xdg-open \${url}";
      };
      mouse = {
        hide-when-typing = "yes";
      };
      colors = {
        alpha = "0.9";
        background = "${config.colorScheme.palette.background}";
        foreground = "${config.colorScheme.palette.foreground}";
        flash = "7f7f00";
        flash-alpha = "0.5";
        # Normal/regular colors (color palette 0-7)
        regular0 = "${config.colorScheme.palette.black}";  # black
        regular1 = "${config.colorScheme.palette.red}";  # red
        regular2 = "${config.colorScheme.palette.green}";  # green
        regular3 = "${config.colorScheme.palette.yellow}";  # yellow
        regular4 = "${config.colorScheme.palette.blue}";  # blue
        regular5 = "${config.colorScheme.palette.magenta}";  # magenta
        regular6 = "${config.colorScheme.palette.cyan}";  # cyan
        regular7 = "${config.colorScheme.palette.white}";  # white
        # Bright colors (color palette 8-15)
        bright0 = "${config.colorScheme.palette.blackBright}";   # bright black
        bright1 = "${config.colorScheme.palette.redBright}";   # bright red
        bright2 = "${config.colorScheme.palette.greenBright}";   # bright green
        bright3 = "${config.colorScheme.palette.yellowBright}";   # bright yellow
        bright4 = "${config.colorScheme.palette.blueBright}";   # bright blue
        bright5 = "${config.colorScheme.palette.magentaBright}";   # bright magenta
        bright6 = "${config.colorScheme.palette.cyanBright}";   # bright cyan
        bright7 = "${config.colorScheme.palette.whiteBright}";   # bright white
      };
    };
  };

}
