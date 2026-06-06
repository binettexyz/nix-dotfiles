{
  flake.modules.homeManager.hyprKeybinds = {
    wayland.windowManager.hyprland.settings = {
      "$mod1" = "SUPER";
      "$mod2" = "SUPERSHIFT";
      "$mod3" = "SUPERCONTROL";
      "$mod4" = "SUPERALT";
      "$mod5" = "ALTCTRL";
      "$terminal" = "foot";
      "$browser" = "librewolf";
      "$editor" = "nvim";
      "$menu" = "wofirun";

      bind = [
        # Important binds
        "$mod1, Q, killactive"
        "$mod2, Delete, exec, uwsm stop"

        # Switch workspaces
        "$mod1, 1, focusworkspaceoncurrentmonitor, 1"
        "$mod1, 2, focusworkspaceoncurrentmonitor, 2"
        "$mod1, 3, focusworkspaceoncurrentmonitor, 3"

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
        "$mod2, 1, movetoworkspacesilent, 1"
        "$mod2, 2, movetoworkspacesilent, 2"
        "$mod2, 3, movetoworkspacesilent, 3"
        "$mod2, Period, movewindow, mon:+1 silent"
        "$mod2, Comma, movewindow, mon:-1 silent"

        "$mod1, Space, togglefloating"
        "$mod1, F , fullscreenstate, 1 0 # Make client maximize"
        "$mod2, F, fullscreenstate, 0 2" # Make app-only fullscreen (fakefullscreen)
        "$mod3, F, fullscreenstate, 2 0" # Make client-only fullscreen

        # Sratchpad
        "$mod1, S, togglespecialworkspace, scratchpad"
        "$mod2, S, movetoworkspacesilent, special:scratchpad"

        "$mod1, C, togglespecialworkspace, discord"
        "$mod2, C, movetoworkspacesilent, special:discord"

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
    };
  };
}
