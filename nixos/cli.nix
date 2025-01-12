{ config, lib, pkgs, ... }: {

  /* ---Set Environment Variables--- */
  environment.variables = {
    # PATH
    #TODO PATH = [ "~/.local/bin" "~/.local/bin/*" ];

    # Default Programs:
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = if config.device == "laptop" then "st" else "konsole";
    BROWSER = if config.device == "laptop" then "qutebrowser" else "librefox";
    READER = if config.device == "laptop" then "zatura" else "";
    SUDO = "doas";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    SHELL = "zsh";
    BAT_THEME = "ansi";

    # Default Home Directories:
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
    INPUTRC = "$HOME/.config/shell/inputrc";
    #KDEHOME = "$HOME/.config/kde";

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
  };


}
