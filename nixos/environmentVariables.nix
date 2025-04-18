{ config, ... }:
{

  environment.localBinInPath = true;
  environment.variables = {
    # Default Programs:
    EDITOR = "(emacsclient -c -a emacs)";
    VISUAL = "(emacsclient -c -a emacs)";
    TERMINAL = "foot";
    BROWSER = if config.device == "laptop" then "qutebrowser" else "librefox";
    READER = "zathura";
    SUDO = "doas";
    MANPAGER = "bat -l man -p";
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
