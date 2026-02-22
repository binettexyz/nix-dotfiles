{
  flake.modules.homeManager.binetteTmux = {
    programs.tmux = {
      enable = true;
      shortcut = "a";
      keyMode = "vi";
      baseIndex = 1;
      clock24 = true;
      terminal = "screen-256color";
    };
  };
}
