{ pkgs, config, lib, ... }:
with lib;

{

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withPython3 = true;

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

      extraConfig = builtins.replaceStrings
        ["<COLOURSCHEME>"] ["catppuccin"]
        (builtins.readFile ./config.vim);

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
    };

      imports = [

        ./plugins/catppuccin-nvim

        ./plugins/coc-nvim
        
        ./plugins/lualine

        ./plugins/nvim-tree-lua

        ./plugins/nvim-treesitter

        ./plugins/orgmode

        ./plugins/vimsence

      ];


  
    home.packages = with pkgs; [ rnix-lsp ];
}
