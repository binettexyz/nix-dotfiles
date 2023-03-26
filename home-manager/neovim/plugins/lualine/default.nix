{ pkgs, ... }:

{
  # Configure neovim
  programs.neovim = {

    # Install plugins related to lualine
    plugins = with pkgs.vimPlugins; [

      # Install lualine
      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          ----------------------------------
          -- lualine
          ----------------------------------

          require('lualine').setup {
            options = {
              theme = "gruvbox-material"
            }
          }
        '';
      }

      # Install devicons to improve appearance
      nvim-web-devicons
    ];
  };
}
