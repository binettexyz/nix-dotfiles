{pkgs, ...}: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = vimwiki;
        type = "lua";
        config = ''
          vim.g.vimwiki_list = {
            {
              path = "~/documents/notes",
              syntax = "markdown",
              ext = ".md"
            }
          }
          vim.g.vimwiki_global_ext = 0
          vim.g.vimwiki_table_mappings = 0
        '';
      }
    ];
  };
}
