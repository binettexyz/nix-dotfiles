{
  deviceRole,
  lib,
  osConfig,
  ...
}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        margin = "8px, 8px, 0px, 8px";
        reload_style_on_change = true;
        output = ["${lib.elemAt osConfig.device.videoOutput 0}"];
        #include = [ ~/.config/waybar/modules.json ];
        modules-left = [
          "custom/nixos"
          "cpu"
          "custom/sep"
          "memory"
          "custom/sep"
          "temperature"
        ];
        modules-center = [
          "clock"
          "custom/sep"
          "custom/notification"
        ];
        modules-right =
          [
            "tray"
            "hyprland/workspaces"
          ]
          ++ (
            if deviceRole == "laptop"
            then [
              "custom/sep"
              "battery"
              "battery#bat2"
              "custom/sep"
            ]
            else []
          )
          ++ [
            "network"
            "custom/sep"
            "pulseaudio"
            "pulseaudio#mic"
            "custom/sep"
            "custom/power"
          ];

        # ---Modules---
        "custom/nixos" = {
          format = " ";
          tooltip = false;
        };
        "custom/sep" = {
          format = "|";
          tooltip = false;
        };
        "custom/power" = {
          format = " ";
          tooltip = false;
          on-click = "sysact";
        };
        "custom/notification" = {
          tooltip = false;
          format = "{} {icon} ";
          format-icons = {
            notification = "<span foreground='#ea6962'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='#ea6962'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='#ea6962'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='#ea6962'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };
        tray = {
          "icon-size" = 21;
          "spacing" = 10;
        };
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          warp-on-scroll = false;
          format = "{name}";
          format-icons = {
            urgent = "";
            active = "";
            default = "";
          };
          persistent-workspaces = {
            "*" = 3;
          };
          tooltip = false;
        };
        pulseaudio = {
          format = "{icon} {volume}% -";
          format-bluetooth = "{icon} {volume}%  {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " Muted -";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            default = [
              ""
              ""
              ">"
            ];
          };
          on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.0";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- -l 1.0";
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          tooltip = false;
        };
        "pulseaudio#mic" = {
          format = "{format_source}";
          format-source = " {volume}%";
          format-source-muted = " Muted";
          on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+ -l 1.0";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%- -l 1.0";
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          tooltip = false;
        };
        network = {
          format-wifi = "{essid}  ";
          format-ethernet = "{ipaddr}/{cidr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ";
          tooltip = false;
        };
        cpu = {
          format = " {usage}%";
          tooltip = false;
        };
        memory = {
          format = " {}%";
          tooltip = false;
        };
        temperature = {
          interval = 10;
          hwmon-path = "/sys/devices/platform/coretemp.0/hwmon/hwmon4/temp1_input";
          critical-threshold = 100;
          format-critical = " {temperatureC}";
          format = " {temperatureC}°C";
          tooltip = false;
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          tooltip = false;
          format = "{icon}  {capacity}%";
          format-full = "{icon}  {capacity}%";
          format-charging = "  {capacity}%";
          format-plugged = "  {capacity}%";
          format-alt = "{time}  {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
        "battery#bat2" = {
          bat = "BAT2";
          tooltip = false;
        };
        clock = {
          format = "{:%A - %B %d, %Y - %R}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          tooltip = true;
        };
        bluetooth = {
          format = " {status}";
          format-connected = " {device_alias}";
          format-connected-battery = " {device_alias} {device_battery_percentage}%";
          format-device-preference = [
            "device1"
            "device2"
          ];
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
          tooltip = false;
        };
      };
      #style = { };
    };
  };
}
