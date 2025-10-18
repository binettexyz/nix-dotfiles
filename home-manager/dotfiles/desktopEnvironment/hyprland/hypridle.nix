{deviceType, lib, osConfig, ...}: {
  services.hypridle = {
    enable = osConfig.programs.hyprland.enable;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = lib.mkMerge [
        [
          {
            timeout = 120;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on && brightnessctl -r";
          }
          {
            timeout = 180;
            on-timeout = "loginctl lock-session";
          }
        ]
        (lib.mkIf (deviceType == "laptop") [
          {
            timeout = 120;
            on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
            on-resume = "brightnessctl -rd rgb:kbd_backlight";
          }
          {
            timeout = 300;
            on-timeout = "systemctl suspend";
          }
        ])
      ];
    };
  };
}
