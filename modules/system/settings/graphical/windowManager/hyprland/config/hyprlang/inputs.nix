{
  flake.modules.homeManager.hyprInputs =
    { config, ... }:
    {
      wayland.windowManager.hyprland.settings = {
        input = {
          kb_layout = "us";
          kb_variant = "altgr-intl";
          kb_model = "pc104";
          kb_options = "caps:swapescape";
          kb_rules = "";
          repeat_rate = 50;
          repeat_delay = 150;
          follow_mouse = 1;
          sensitivity = config.modules.hm.hyprland.general.sensitivity;
          accel_profile = config.modules.hm.hyprland.general.accel_profile;
          touchpad = {
            natural_scroll = true;
          };
        };

        cursor = {
          hide_on_key_press = true;
          no_hardware_cursors = false;
        };
      };
    };
}
