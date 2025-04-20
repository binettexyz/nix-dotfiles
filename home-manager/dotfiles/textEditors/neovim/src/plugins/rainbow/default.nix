{ pkgs, ... }:

{
  # Configure neovim
  programs.neovim = {

    # Install rainbow FIXME: broke nix syntax
    plugins = with pkgs.vimPlugins; [
      {
        plugin = rainbow;
        type = "viml";
        config = ''
          let g:rainbow_active = 1
        '';
      }
    ];
  };
}
