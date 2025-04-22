{config, ...}: let
  cfg = config.colorScheme.palette;
in {
  programs.waybar.style = ''

    * {
      font-family: monospace;
      font-size: 14px;
      font-weight: 600;
      min-height: 25px;
      border-radius: 4px;
    }

    window#waybar {
      background: alpha(#${cfg.background}, 0.96);
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
      color: #d4be98;
      /*background: #282828;*/
      border-radius: 4px;
      margin: 4px 0px 4px 0px;
      padding: 0px 0px 0px 8px;
    }

    #custom-sep {
      color: #d4be98;
      background: #282828;
      border-radius: 0px;
      border-right: 0px;
      border-left: 0px;
      margin-left: 0px;
      padding: 0px 0px 0px 0px;
    }
    #custom-notification {
      background: #282828;
      border-radius: 0px 4px 4px 0px;
      padding: 0px 0px 0px 2px;
    }

    #clock {
      background: #282828;
      border-radius: 4px 0px 0px 4px;
      padding: 0px 2px 0px 4px;
    }

    #custom-nixos {
      font-size: 20px;
      color: #7daea3;
      background: #282828;
      border-radius: 4px;
      padding: 0px 0px 0px 4px;
      margin: 0px 4px 0px 0px;
    }

    #cpu {
      color: #d4be98;
      background: #282828;
      border-radius: 4px 0px 0px 4px;
      border-right: 0px;
      padding: 0px 4px 0px 4px;
      min-width: 18px;
    }

    #memory {
      color: #d4be98;
      background: #282828;
      border-radius: 0px 0px 0px 0px;
      border-left: 0px;
      border-right: 0px;
      padding: 0px 4px 0px 4px;
    }

    #temperature {
      color: #d4be98;
      background: #282828;
      border-radius: 0px 4px 4px 0px;
      border-left: 0px;
      padding: 0px 4px 0px 4px;
    }

    #tray {
      background: #282828;
      border-radius: 4px;
      margin-right: 4px;
      padding-right: 2px;
      padding-left: 2px;
    }

    #workspaces {
      background: #282828;
      border-radius: 4px;
      margin-right: 4px;
    }

    #workspaces button {
      color: #d4be98;
      padding: 0;
      margin-right: 0px;
    }

    #workspaces button.active {
      color: #7daea3;
    }

    #workspaces button.empty {
      color: #928374;
    }

    #workspaces button.empty.active {
      color: #7daea3;
    }

    #network {
      color: #d4be98;
      background: #282828;
      border-radius: 4px 0px 0px 4px;
      border-right: 0px;
      padding: 0px 4px 0px 4px;
      min-width: 18px;
    }

    #pulseaudio {
      color: #d4be98;
      background: #282828;
      border-radius: 0px 0px 0px 0px;
      border-left: 0px;
      border-right: 0px;
      padding: 0px 4px 0px 4px;
    }

    #custom-power {
      background: #282828;
      color: #ea6962;
      border-radius: 0px 4px 4px 0px;
      border-left: 0px;
      padding: 0px 2px 0px 4px;
      margin: 0px 4px 0px 0px;
    }

  '';
}
