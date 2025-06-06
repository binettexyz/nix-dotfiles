{pkgs, ...}: {
  # Configure neovim
  programs.neovim = {
    # Install vimsence
    plugins = [
      {
        plugin = pkgs.vimPlugins.vimsence;
        type = "viml";
        config = ''
          let g:vimsence_client_id = '439476230543245312'
          let g:vimsence_small_text = 'NeoVim'
          let g:vimsence_small_image = 'neovim'
          let g:vimsence_editing_details = 'Editing: {}'
          let g:vimsence_editing_state = 'Working on: {}'
          let g:vimsence_file_explorer_text = 'In NERDTree'
          let g:vimsence_file_explorer_details = 'Looking for files'
          "let g:vimsence_custom_icons = {'filetype': 'iconname'}
        '';
      }
    ];
  };
}
