{
  config,
  lib,
  pkgs,
  ...
}:
with lib;

{

  environment.localBinInPath = true;
  environment.variables = {
    # Default Programs:
    EDITOR = "emacsclient -t -a ''";
    VISUAL = "emacsclient -c -a emacs";
    TERMINAL = "foot";
    BROWSER = if config.device == "laptop" then "qutebrowser" else "librefox";
    READER = "zathura";
    SUDO = "doas";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    SHELL = "zsh";

    # Themes
    BAT_THEME = "ansi";
    LS_COLORS = "lf";

    # Default Home Directories:
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
    INPUTRC = "$HOME/.config/shell/inputrc";

    # ~/ Clean-up:
    XINITRC = "$HOME/.config/x11/xinitrc";
    XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority"; # This line will break some DMs.
    GTK2_RC_FILES = "$HOME/.config/gtk-2.0/gtkrc-2.0";
    LESSHISTFILE = "-";
    ZDOTDIR = "$HOME/.config/zsh";
    GNUPGHOME = "$HOME/.local/share/gnupg";
    PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
    TMUX_TMPDIR = "$XDG_RUNTIME_DIR";
    HISTFILE = "$HOME/.local/share/history";

    # Other Program Settings:
    MOZ_USE_XINPUT2 = "1";
    _JAVA_AWT_WM_NONREPARENTING = 1;

    # Wayland
    XDG_SESSION_TYPE = "wayland"; # Tell apps you're using Wayland
    XDG_CURRENT_DESKTOP = "qtile"; # Required by xdg-desktop-portal for screen sharing
    XDG_SEAT = "seat0"; # Some apps need this to use the correct seat

    # Prefer Wayland-native backends if available
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    GDK_BACKEND = "wayland,x11";

    # Some Electron apps can use Wayland with this
    MOZ_ENABLE_WAYLAND = 1; # Firefox (GTK)
    MOZ_WEBRENDER = 1; # Firefox rendering
    OZONE_PLATFORM = "wayland"; # Electron/Chromium (Wayland support)
  };

}
