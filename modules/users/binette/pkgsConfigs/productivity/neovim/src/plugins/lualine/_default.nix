{ pkgs, ... }:
{
  # Configure neovim
  programs.neovim = {
    # Install plugins related to lualine
    plugins = [
      # Install lualine
      {
        plugin = pkgs.vimPlugins.lualine-nvim;
        type = "lua";
        config = ''
          ----------------------------------
          -- lualine
          ----------------------------------

          require('lualine').setup {
            options = {
              theme = "auto"
            }
          }
        '';
      }

      # Install devicons to improve appearance
      pkgs.vimPlugins.nvim-web-devicons
    ];
  };
}
