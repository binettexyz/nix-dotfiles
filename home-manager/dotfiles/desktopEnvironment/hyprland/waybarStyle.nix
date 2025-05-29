{
  config,
  lib,
  ...
}: let
  cfg = config.modules.hm.theme.colorScheme;
  cfgColor = config.colorScheme.palette;
in {
  #TODO: Add mkMerge per host.
  programs.waybar.style = lib.mkIf config.programs.waybar.enable ''

    * {
      font-family: monospace;
      font-size: 14px;
      font-weight: 600;
      min-height: 25px;
      border-radius: 4px;
    }

    window#waybar {
      background: #${cfgColor.bg0};
    }

    .modules-left {
      border: 0px;
      margin: 4px 0px 4px 4px;
    }

    .modules-right {
      border: 0px;
      margin: 4px 0px 4px 4px;
    }

    .modules-center {
      color: #${cfgColor.fg0};
      /*background: #${cfgColor.bg2};*/
      border-radius: 4px;
      margin: 4px 0px 4px 0px;
      padding: 0px 0px 0px 8px;
    }

    #custom-sep {
      color: #${cfgColor.fg0};
      background: #${cfgColor.bg2};
      border-radius: 0px;
      border-right: 0px;
      border-left: 0px;
      margin-left: 0px;
      padding: 0px 0px 0px 0px;
    }
    #custom-notification {
      background: #${cfgColor.bg2};
      border-radius: 0px 4px 4px 0px;
      padding: 0px 0px 0px 2px;
    }

    #clock {
      background: #${cfgColor.bg2};
      border-radius: 4px 0px 0px 4px;
      padding: 0px 2px 0px 4px;
    }

    #custom-nixos {
      font-size: 20px;
      color: #${
      if cfg == "catppuccin"
      then cfgColor.peach
      else if cfg == "gruvbox"
      then cfgColor.blue
      else if cfg == "jmbi"
      then cfgColor.red
      else cfgColor.fg0
    };
      background: #${cfgColor.bg2};
      border-radius: 4px;
      padding: 0px 0px 0px 4px;
      margin: 0px 4px 0px 0px;
    }

    #cpu {
      color: #${cfgColor.fg0};
      background: #${cfgColor.bg2};
      border-radius: 4px 0px 0px 4px;
      border-right: 0px;
      padding: 0px 4px 0px 4px;
      min-width: 18px;
    }

    #memory {
      color: #${cfgColor.fg0};
      background: #${cfgColor.bg2};
      border-radius: 0px 0px 0px 0px;
      border-left: 0px;
      border-right: 0px;
      padding: 0px 4px 0px 4px;
    }

    #temperature {
      color: #${cfgColor.fg0};
      background: #${cfgColor.bg2};
      border-radius: 0px 4px 4px 0px;
      border-left: 0px;
      padding: 0px 4px 0px 4px;
    }

    #tray {
      background: #${cfgColor.bg2};
      border-radius: 4px;
      margin-right: 4px;
      padding-right: 2px;
      padding-left: 2px;
    }

    #battery {
      color: #${cfgColor.fg0};
      background: #${cfgColor.bg2};
      border-radius: 4px;
      margin-right: 4px;
      padding: 0px 4px 0px 4px;
    }

    #battery#2 {
      color: #${cfgColor.fg0};
      background: #${cfgColor.bg2};
      border-radius: 4px;
      margin-right: 4px;
      padding: 0px 4px 0px 4px;
    }

    #workspaces {
      background: #${cfgColor.bg2};
      border-radius: 4px;
      margin-right: 4px;
    }

    #workspaces button {
      color: #${cfgColor.fg2};

      padding: 0;
      margin-right: 0px;
    }

    #workspaces button.active {
      color: #${
      if cfg == "catppuccin"
      then cfgColor.peach
      else if cfg == "gruvbox"
      then cfgColor.blue
      else if cfg == "jmbi"
      then cfgColor.blue
      else cfgColor.fg0
    };
    }

    #workspaces button.empty {
      color: #${cfgColor.blackBright};
    }

    #workspaces button.empty.active {
      color: #${
      if cfg == "catppuccin"
      then cfgColor.peach
      else if cfg == "gruvbox"
      then cfgColor.blue
      else if cfg == "jmbi"
      then cfgColor.blue
      else cfgColor.fg0
    };
    }

    #network {
      color: #${cfgColor.fg0};
      background: #${cfgColor.bg2};
      border-radius: 4px 0px 0px 4px;
      border-right: 0px;
      padding: 0px 4px 0px 4px;
      min-width: 18px;
    }

    #pulseaudio {
      color: #${cfgColor.fg0};
      background: #${cfgColor.bg2};
      border-radius: 0px 0px 0px 0px;
      border-left: 0px;
      border-right: 0px;
      padding: 0px 4px 0px 4px;
    }

    #custom-power {
      background: #${cfgColor.bg2};
      color: #${cfgColor.red};
      border-radius: 0px 4px 4px 0px;
      border-left: 0px;
      padding: 0px 2px 0px 4px;
      margin: 0px 4px 0px 0px;
    }

  '';
}
