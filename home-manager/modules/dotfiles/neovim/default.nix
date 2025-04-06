{
  pkgs,
  config,
  lib,
  ...
}:
with lib;

{

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = true;
    withRuby = false;
    withNodeJs = false;

    plugins = with pkgs.vimPlugins; [
      # Language servers
      vim-nix
      # Quality of life
      colorizer
      vim-illuminate
      auto-pairs
      quick-scope
      telescope-nvim
    ];

    extraConfig = builtins.replaceStrings [ "<COLOURSCHEME>" ] [ "gruvbox-material" ] (
      builtins.readFile ./src/config.vim
    );

    # TODO: convert theses to lua.
    #      extraConfig = lib.strings.concatStringsSep "\n" [
    #        ''
    #            " Disables automatic commenting on newline:
    #          autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
    #        ''
    #          # Custom Fontions
    #        ''
    #            " Save file as sudo on files that require root permission
    #          command! W execute 'w !doas tee % > /dev/null' <bar> edit!
    #
    #            " Check file in shellcheck:
    #    	    map <leader>s :!clear && shellcheck -x %<CR>
    #
    #            " Compile document, be it groff/LaTeX/markdown/etc.
    #    	    map <leader>c :w! \| !compiler "<c-r>%"<CR>
    #
    #          autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
    #          autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
    #          autocmd BufRead,BufNewFile *.tex set filetype=tex
    #          autocmd BufRead,BufNewFile *.nix set filetype=nix

    #" Runs a script that cleans out tex build files whenever I close out of a .tex file.
    #	autocmd VimLeave *.tex !texclear %
  };

  imports = [

    ./src/plugins/catppuccin-nvim

    # TODO: replace coc by nvim native lsp
    ./src/plugins/coc-nvim

    ./src/plugins/gruvbox-material

    ./src/plugins/lualine

    ./src/plugins/nvim-tree-lua

    ./src/plugins/nvim-treesitter

    ./src/plugins/orgmode

    ./src/plugins/vim-latex-live-preview

    ./src/plugins/vimsence

    #FIXME: ./src/plugins/vimtex

  ];

  home.packages =
    with pkgs;
    [
      # rnix-lsp
    ];
}
