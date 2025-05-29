{pkgs, ...}: {
  # Configure neovim
  programs.neovim = {
    # Install plugins related to treesitter
    plugins = [
      # Install nvim-treesitter
      {
        plugin = pkgs.vimPlugins.nvim-treesitter;
        type = "lua";
        config = builtins.readFile ./config.lua;
      }
    ];
  };
}
