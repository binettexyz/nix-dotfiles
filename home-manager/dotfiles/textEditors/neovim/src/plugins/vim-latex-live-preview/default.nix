{ pkgs, ... }:

{
  # Configure neovim
  programs.neovim = {

    # Install vim-latex-live-preview
    plugins = with pkgs.vimPlugins; [
      {
        plugin = vim-latex-live-preview;
        type = "viml";
        config = ''
          let g:livepreview_previewer = 'zathura'
        '';
      }
    ];
  };

}
