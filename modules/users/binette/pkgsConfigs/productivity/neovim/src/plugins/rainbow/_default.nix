{ pkgs, ... }:
{
  # Configure neovim
  programs.neovim = {
    # Install rainbow FIXME: broke nix syntax
    plugins = [
      {
        plugin = pkgs.vimPlugins.rainbow;
        type = "viml";
        config = ''
          let g:rainbow_active = 1
        '';
      }
    ];
  };
}
