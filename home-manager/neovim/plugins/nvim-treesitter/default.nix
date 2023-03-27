{ pkgs, ... }:

{
    # Configure neovim
  programs.neovim = {

      # Install plugins related to treesitter
    plugins = with pkgs.vimPlugins; [

        # Install nvim-treesitter
      {
        plugin = nvim-treesitter;
        type = "lua";
        config = builtins.readFile ./config.lua;
      }

    ];
  };

}
