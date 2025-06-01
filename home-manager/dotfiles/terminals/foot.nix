{
  config,
  deviceTags,
  lib,
  pkgs,
  ...
}: {
  programs.foot = {
    enable =
      if lib.elem "workstation" deviceTags
      then true
      else false;
    package = pkgs.stable.foot;
    settings = {
      main = {
        font = "monospace:size=10";
      };
      cursor = {
        style = "beam";
        beam-thickness = 1;
        color = "${config.colorScheme.palette.bg0} ${config.colorScheme.palette.fg0}";
      };
      url = {
        launch = "xdg-open \${url}";
      };
      mouse = {
        hide-when-typing = "yes";
      };
      key-bindings = {
        clipboard-copy = "Control+Shift+c XF86Copy";
        clipboard-paste = "Control+Shift+v XF86Paste";
        scrollback-up-line = "Mod1+k";
        scrollback-down-line = "Mod1+j";
        font-increase = "Mod1+Shift+K";
        font-decrease = "Mod1+Shift+j";
        font-reset = "Control+0";
      };
      search-bindings = {
        # unbind keys
        cancel = "Escape";
      };
      url-bindings = {
        # unbind keys
        cancel = "Escape";
      };
      colors = {
        alpha = "0.9";
        background = "${config.colorScheme.palette.bg0}";
        foreground = "${config.colorScheme.palette.fg0}";
        flash = "7f7f00";
        flash-alpha = "0.5";
        # Normal/regular colors (color palette 0-7)
        regular0 = "${config.colorScheme.palette.black}"; # black
        regular1 = "${config.colorScheme.palette.red}"; # red
        regular2 = "${config.colorScheme.palette.green}"; # green
        regular3 = "${config.colorScheme.palette.yellow}"; # yellow
        regular4 = "${config.colorScheme.palette.blue}"; # blue
        regular5 = "${config.colorScheme.palette.magenta}"; # magenta
        regular6 = "${config.colorScheme.palette.cyan}"; # cyan
        regular7 = "${config.colorScheme.palette.white}"; # white
        # Bright colors (color palette 8-15)
        bright0 = "${config.colorScheme.palette.blackBright}"; # bright black
        bright1 = "${config.colorScheme.palette.redBright}"; # bright red
        bright2 = "${config.colorScheme.palette.greenBright}"; # bright green
        bright3 = "${config.colorScheme.palette.yellowBright}"; # bright yellow
        bright4 = "${config.colorScheme.palette.blueBright}"; # bright blue
        bright5 = "${config.colorScheme.palette.magentaBright}"; # bright magenta
        bright6 = "${config.colorScheme.palette.cyanBright}"; # bright cyan
        bright7 = "${config.colorScheme.palette.whiteBright}"; # bright white
      };
    };
  };
}
