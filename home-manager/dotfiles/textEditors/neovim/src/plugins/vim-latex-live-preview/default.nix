{pkgs, ...}: {
  # Configure neovim
  programs.neovim = {
    # Install vim-latex-live-preview
    plugins = [
      {
        plugin = pkgs.vimPlugins.vim-latex-live-preview;
        type = "viml";
        config = ''
          let g:livepreview_previewer = 'zathura'
        '';
      }
    ];
  };
}
