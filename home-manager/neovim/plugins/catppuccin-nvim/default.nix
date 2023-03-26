{ pkgs, ... }:

{
    # Configure neovim
  programs.neovim = {

    # Install catppuccin-nvim
    plugins = with pkgs.vimPlugins; [{
      plugin = catppuccin-nvim;
      type = "lua";
      config = builtins.readFile ./config.lua;
    }];
  };

}
