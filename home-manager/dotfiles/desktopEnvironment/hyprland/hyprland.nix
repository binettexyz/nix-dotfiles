{
  config,
  lib,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod1" = "SUPER";
      "$mod2" = "SUPERSHIFT";
      "$mod3" = "SUPERCONTROL";
      "$mod4" = "SUPERALT";
      "$mod5" = "ALTCTRL";
      "$terminal" = "foot";
      "$browser" = "qutebrowser";
      "$editor" = "nvim";
      "$menu" = "wofirun";

      env = [
        "QT_QPA_PLATFORM,wayland"
        "SDL_VIDEODRIVER,wayland"
        "CLUTTER_BACKEND,wayland"
        "GDK_BACKEND,wayland"
        "MOZ_ENABLE_WAYLAND,1"
        "MOZ_WEBRENDER,1"
        "OZONE_PLATFORM,wayland"
        "NIXOS_OZONE_WL,1"
        "HYPRCURSOR_THEME,${config.gtk.cursorTheme.name}"
        "HYPRCURSOR_SIZE,${toString config.gtk.cursorTheme.size}"
        "XCURSOR_THEME,${config.gtk.cursorTheme.name}"
        "XCURSOR_SIZE,${toString config.gtk.cursorTheme.size}"
      ];

      monitor = config.modules.hm.hyprland.monitor;

      exec-once = config.modules.hm.hyprland.exec-once;

      general = {
        allow_tearing = false;
        border_size = 2;
        "col.active_border" = "rgba(${config.colorScheme.palette.activeBorder}aa)";
        "col.inactive_border" = "rgba(${config.colorScheme.palette.inactiveBorder}aa)";
        gaps_in = 8;
        gaps_out = 8;
        layout = "dwindle";
        no_border_on_floating = false;
        resize_on_border = false;
      };

      decoration = {
        rounding = 10;
        rounding_power = 2;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
        shadow = {
          enabled = 
          if lib.elem "lowSpec" config.modules.device.tags
          then false
          else true;
        };
      };

      animations = {
        enabled =
          if lib.elem "lowSpec" config.modules.device.tags
          then false
          else true;
        bezier = [
          "smoothIn, 0.25, 1, 0.5, 1"
          "pace, 0.46, 1, 0.29, 0.99"
          "smoothOut, 0.36, 0, 0.66, -0.56"
          "overshot, 0.05, 0.9, 0.1, 1.05"
        ];
        animation = [
          "fade, 1, 3, smoothIn"
          "windowsIn, 1, 3, smoothIn"
          "windowsOut, 1, 3, smoothOut"
          "windowsMove, 1, 3, pace, slide"
          "workspaces, 1, 2, default"
          "layers, 1, 2, pace, slide"
          "specialWorkspace, 1, 3, pace, slidevert"
        ];
      };

      dwindle = {
        # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        pseudotile = true;
        preserve_split = true; # You probably want this
      };

      misc = {
        # Set to 0 or 1 to disable the anime mascot wallpapers
        force_default_wallpaper = 0;
        # If true disables the random hyprland logo / anime girl background.
        disable_hyprland_logo = true;
        # Lower the amount of sent frames when nothing is happening on-screen.
        vfr = true;
      };

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

      bind = [
        # Important binds
        "$mod1, Q, killactive"
        "$mod2, Delete, exec, uwsm stop"

        # Switch workspaces
        #"$mod1, 1, workspace, 1"
        #"$mod1, 2, workspace, 2"
        #"$mod1, 3, workspace, 3"
        "$mod1, 1, split:workspace, 1"
        "$mod1, 2, split:workspace, 2"
        "$mod1, 3, split:workspace, 3"

        # Move Focus
        "$mod1, H, movefocus, l"
        "$mod1, L, movefocus, r"
        "$mod1, K, movefocus, u"
        "$mod1, J, movefocus, d"
        "$mod1, Period, focusmonitor, +1"
        "$mod1, Comma, focusmonitor, -1"

        # Move active window
        "$mod2, H, movewindow, l"
        "$mod2, L, movewindow, r"
        "$mod2, K, movewindow, u"
        "$mod2, J, movewindow, d"
        #"$mod2, 1, movetoworkspacesilent, 1"
        #"$mod2, 2, movetoworkspacesilent, 2"
        #"$mod2, 3, movetoworkspacesilent, 3"
        "$mod2, 1, split:movetoworkspacesilent, 1"
        "$mod2, 2, split:movetoworkspacesilent, 2"
        "$mod2, 3, split:movetoworkspacesilent, 3"
        "$mod2, Period, movewindow, mon:+1 silent"
        "$mod2, Comma, movewindow, mon:-1 silent"

        "$mod1, Space, togglefloating"
        "$mod1, F , fullscreenstate, 1 0 # Make client maximize"
        "$mod2, F, fullscreenstate, 0 2" # Make app-only fullscreen (fakefullscreen)
        "$mod3, F, fullscreenstate, 2 0" # Make client-only fullscreen
        "$mod1, P, pseudo" # dwindle
        "$mod1, I, togglesplit" # dwindle

        # Sratchpad
        "$mod1, S, togglespecialworkspace, scratchpad"
        "$mod2, S, split:movetoworkspacesilent, special:scratchpad"

        "$mod1, C, togglespecialworkspace, discord"
        "$mod2, C, split:movetoworkspacesilent, special:discord"

        # Apps Launched with SUPER + KEY
        "$mod1, Return, exec, $terminal"
        "$mod1, E, exec, $editor"
        "$mod1, D, exec, $menu"

        # Apps Launched with SUPER + ALT + KEY
        "$mod4, b, exec, $browser"
        "$mod4, d, exec, discord"

        # Apps Launched with SUPER + SHIFT + KEY
        "$mod2, Q, exec, sysact"
        "$mod2, P, exec, screenshot"

        # Apps Launched with CTRL + ALT + KEY
        "$mod5, C, exec, clipboard"
        "$mod5, B, exec, bookmarks"
        "$mod5, Y, exec, bookmarkthis"
      ];

      bindm = [
        "$mod1, mouse:272, movewindow"
        "$mod1, mouse:273, resizewindow"
      ];

      binde = [
        # Resize active window
        "$mod3, H, resizeactive, -20 0"
        "$mod3, L, resizeactive, 20 0"
        "$mod3, K, resizeactive, 0 -20"
        "$mod3, J, resizeactive, 0 20"
      ];

      bindel = [
        # Laptop multimedia keys for volume and LCD brightness
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      bindl = [
        # trigger when the switch is turning off
        ",switch:off:Lid Switch,exec,hyprctl keyword monitor 'eDP-1, 1920x1080, 0x0, 1'"
        # trigger when the switch is turning on
        ",switch:on:Lid Switch,exec,hyprctl keyword monitor 'eDP-1, disable'"
      ];

      bindr = [
        #wofi
      ];

      layerrule = [
        "noanim,selection"
      ];

      windowrulev2 = [
        #TODO: Add mkMerge per host.
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

        "workspace 2 silent, class:librewolf"
        "workspace 2 silent, class:^(.*qutebrowser.*)$"
        "workspace 3 silent, class:^(.*Minecraft.*)$"
        "workspace 3 silent, class:gamescope"
        "workspace 5 silent, class:$(.*mpv.*)$"
        "workspace special:discord silent, class:discord"
        "workspace special:discord silent, class:vesktop"
        "workspace 3 silent, class:^(.*steam.*)$"
        "workspace special:steam silent, class:^(.*lutris.*)$"
        "workspace special:steam silent, class:^(.*prismlauncher.*)$"
      ];

      workspace = [
        "special:scratchpad, on-created-empty:foot"
      ];

      plugin = {
        hyprsplit.num_workspaces = 3;
      };
    };
    
    plugins = [
      pkgs.hyprlandPlugins.hyprsplit
    ];
  };
}
