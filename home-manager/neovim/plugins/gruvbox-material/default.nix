{ pkgs, ... }:

{
  # Configure neovim
  programs.neovim = {

    # Install gruvbox-material
    plugins = with pkgs.vimPlugins; [{
      plugin = gruvbox-material;
      type = "viml";
      config = ''
        " Available values: 'hard', 'medium'(default), 'soft'
        let g:gruvbox_material_background = 'hard'
        let g:gruvbox_material_transparent_background = 1
      '';
    }];
  };
}
