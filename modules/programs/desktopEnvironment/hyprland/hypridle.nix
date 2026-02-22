{
  flake.modules.homeManager.hypridle =
    {
      config,
      lib,
      ...
    }:
    {
      services.hypridle = {
        enable = true;
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
            (lib.mkIf (config.modules.device.type == "laptop") [
              {
                timeout = 120;
                on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
                on-resume = "brightnessctl -rd rgb:kbd_backlight";
              }
              {
                timeout = 1800;
                on-timeout = "systemctl suspend";
              }
            ])
          ];
        };
      };
    };
}
