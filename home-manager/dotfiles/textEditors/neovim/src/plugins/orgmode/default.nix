{ pkgs, ... }:

{
  # Configure neovim
  programs.neovim = {

    # Install orgmode
    plugins = with pkgs.vimPlugins; [
      {
        plugin = orgmode;
        type = "lua";
        config = builtins.readFile ./config.lua;
      }
    ];
  };

}
