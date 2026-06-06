{
  flake.modules.homeManager.hyprWorkspaces = {
    wayland.windowManager.hyprland.settings = {
      windowrule = [
        #TODO: Add mkMerge per host.
        "suppress_event maximize, match:class .*"
        "no_focus on, match:class ^$, match:title ^$, match:xwayland 1, match:float 1,match:fullscreen 0, match:pin 0"

        "workspace 2 silent, match:class librewolf"
        "workspace 2 silent, match:class ^(.*qutebrowser.*)$"

        "workspace 3 silent, match:class ^(.*Minecraft.*)$"
        "workspace 3 silent, match:class gamescope"
        "workspace 3 silent, match:class ^(.*steam.*)$"

        "workspace special:discord silent, match:class discord"
        "workspace special:discord silent, match:class vesktop"

        "workspace 3 silent, match:class ^(.*lutris.*)$"
        "workspace 3 silent, match:class ^(.*prismlauncher.*)$"
      ];

      workspace = [
        "special:scratchpad, on-created-empty:foot"
      ];
    };
  };
}
