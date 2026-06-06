{
  flake.modules.homeManager.waybar =
    {
      config,
      lib,
      ...
    }:
    {
      programs.waybar = {
        enable = true;
        systemd.enable = false;
        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            margin =
              if config.modules.device.type == "desktop" then
                "8px, 8px, 0px, 8px"
              else if config.modules.device.type == "laptop" then
                "4px, 4px, 0px, 4px"
              else
                "";
            reload_style_on_change = true;
            #output = ["${lib.elemAt osConfig.device.videoOutput 0}"];
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
            modules-right = [
              "tray"
              "hyprland/workspaces"
            ]
            ++ (
              if (lib.elem "battery" config.modules.device.tags) then
                [
                  "battery"
                  "battery#bat1"
                ]
              else
                [ ]
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
                notification = "<span foreground='#${config.colorScheme.palette.red}'><sup></sup></span>";
                none = "";
                dnd-notification = "<span foreground='#${config.colorScheme.palette.red}'><sup></sup></span>";
                dnd-none = "";
                inhibited-notification = "<span foreground='#${config.colorScheme.palette.red}'><sup></sup></span>";
                inhibited-none = "";
                dnd-inhibited-notification = "<span foreground='#${config.colorScheme.palette.red}'><sup</sup></span>";
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
              active-only = true;
              disable-scroll = true;
              warp-on-scroll = false;
              format = "{name}";
              format-icons = {
                urgent = "";
                active = "";
                default = "";
              };
              persistent-workspaces = {
                "1" = [ ];
                "2" = [ ];
                "3" = [ ];
              };
              sort-by-name = false;
              sort-by-coordinates = false;
              sort-by-number = false;
              tooltip = false;
            };
            pulseaudio = {
              format = "{icon} {volume}% -";
              format-bluetooth = "{icon} {volume}%  {format_source}";
              format-bluetooth-muted = " {icon} {format_source}";
              format-muted = "<span foreground='#${config.colorScheme.palette.red}' size='100%'> Muted</span> -";
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
              format-source-muted = "<span foreground='#${config.colorScheme.palette.red}' size='100%'> Muted</span>";
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
              format-critical = "<span foreground='#${config.colorScheme.palette.red}' size='100%'></span> {temperatureC}";
              format = " {temperatureC}°C";
              tooltip = false;
            };
            battery = {
              bat = "BAT0";
              full-at = 95;
              states = {
                warning = 30;
                critical = 15;
              };
              tooltip = false;
              format = "{icon} {capacity}%";
              format-full = "{icon} {capacity}%";
              format-charging = "<span foreground='#${config.colorScheme.palette.green}' size='100%'></span> {capacity}%";
              format-plugged = " {capacity}%";
              format-alt = "{time} {icon}";
              format-icons = [
                "<span foreground='#${config.colorScheme.palette.red}' size='100%'></span>"
                "<span foreground='#${config.colorScheme.palette.yellow}' size='100%'></span>"
                "<span foreground='#${config.colorScheme.palette.yellow}' size='100%'></span>"
                "<span foreground='#${config.colorScheme.palette.green}' size='100%'></span>"
                "<span foreground='#${config.colorScheme.palette.green}' size='100%'></span>"
              ];
            };
            "battery#bat1" = {
              bat = "BAT1";
              full-at = 95;
              states = {
                warning = 30;
                critical = 15;
              };
              tooltip = false;
              format = "{icon} {capacity}%";
              format-full = "{icon} {capacity}%";
              format-charging = "<span foreground='#${config.colorScheme.palette.green}' size='100%'></span> {capacity}%";
              format-plugged = " {capacity}%";
              format-alt = "{time} {icon}";
              format-icons = [
                "<span foreground='#${config.colorScheme.palette.red}' size='100%'></span>"
                "<span foreground='#${config.colorScheme.palette.yellow}' size='100%'></span>"
                "<span foreground='#${config.colorScheme.palette.yellow}' size='100%'></span>"
                "<span foreground='#${config.colorScheme.palette.green}' size='100%'></span>"
                "<span foreground='#${config.colorScheme.palette.green}' size='100%'></span>"
              ];
            };
            clock = {
              format = "{:%A - %B %d, %Y - %R}";
              tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
              tooltip = false;
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
    };
}
