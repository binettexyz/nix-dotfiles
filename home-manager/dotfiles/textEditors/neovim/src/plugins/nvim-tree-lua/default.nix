{pkgs, ...}: {
  # Configure neovim
  programs.neovim = {
    # Install plugins related to nvim-tree plugin
    plugins = [
      # Install nvim-tree
      {
        plugin = pkgs.vimPlugins.nvim-tree-lua;
        type = "lua";
        config = builtins.readFile ./config.lua;
      }

      # Install devicons to improve appearance
      pkgs.vimPlugins.nvim-web-devicons
    ];
  };
}
