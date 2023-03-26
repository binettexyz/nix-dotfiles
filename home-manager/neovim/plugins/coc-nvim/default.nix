{ pkgs, lib, ... }:
with lib;

{
  # Configure neovim
  programs.neovim = {

    # Install coc
    coc = {
      enable = true;
      pluginConfig = lib.strings.concatStringsSep "\n" [
          # use <tab> for trigger completion and navigate to the next complete item:
        ''
          function! CheckBackspace() abort
            let col = col('.') - 1
            return !col || getline('.')[col - 1]  =~# '\s'
          endfunction

          inoremap <silent><expr> <Tab>
            \ coc#pum#visible() ? coc#pum#next(1) :
            \ CheckBackspace() ? "\<Tab>" :
            \ coc#refresh()
        ''
          # Use <Tab> and <S-Tab> to naviguate the completion list:
        ''
          inoremap <expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
          inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"
        ''
      ];

        # https://github.com/neoclide/coc.nvim/blob/master/data/schema.json
        # ~/.config/nvim/coc-settings.json
      settings = {
        "suggest.noselect" = true;
        "suggest.enablePreview" = true;
        "suggest.enablePreselect" = false;
        "languageserver" = {
            # https://gitlab.com/jD91mZM2/nix-lsp
          "nix" = {
            "command" = "rnix-lsp";
            "filetypes" = [
              "nix"
            ];
          };
        };
      };
    };

    # Install plugins related to coc plugin
    plugins = with pkgs.vimPlugins; [
      coc-clangd
      coc-python
      coc-prettier
      coc-pairs
    ];
  };
}
