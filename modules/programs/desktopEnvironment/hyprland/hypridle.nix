{
  flake.modules.homeManager.hypridle =
    {
      config,
      lib,
      ...
    }:
    {
      services.hypridle = {
        enable = false;
        settings = {
          general = {
            lock_cmd = "pidof hyprlock || hyprlock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };
          listener = lib.mkMerge [
            [
              {
                timeout = 600;
                on-timeout = "hyprctl dispatch dpms off";
                on-resume = "hyprctl dispatch dpms on && brightnessctl -r";
              }
              {
                timeout = 600;
                on-timeout = "loginctl lock-session";
              }
            ]
            (lib.mkIf (config.modules.device.type == "laptop") [
              {
                timeout = 600;
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
