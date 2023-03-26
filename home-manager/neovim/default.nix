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
#          "let mapleader =","
#    
#            " Disables automatic commenting on newline:
#          autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
#    
#            " Perform dot commands over visual blocks:
#          vnoremap . :normal .<CR>
#    
#            " Spell-check set to <leader>o:
#          "map <leader>oe :setlocal spell! spelllang=en_us<CR>
#          "map <leader>of :setlocal spell! spelllang=fr<CR>
#    
#            " Splits open at the bottom and right.
#          set splitbelow splitright
#
#            " split navigation:
#    	    "map <C-h> <C-w>h
#    	    "map <C-j> <C-w>j
#    	    "map <C-k> <C-w>k
#    	    "map <C-l> <C-w>l
#
#        ''
#          # Plugins config
#        ''
#          map <leader>n :NERDTreeToggle<CR>
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
#            " Ensure files are read as what I want:
#          let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
#          map <leader>v :VimwikiIndex<CR>
#          let g:vimwiki_list = [{'path': '~/.local/share/nvim/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
#          autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
#          autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
#          autocmd BufRead,BufNewFile *.tex set filetype=tex
#          autocmd BufRead,BufNewFile *.nix set filetype=nix
#
#
#
#        ''
#          # Visual
#        ''
#          "colorscheme gruvbox-material
#          "set title
#          set termguicolors
#          set background=dark
#          "set number relativenumber
#          set noruler
#          "set wrap
#          "set showmatch
#          set matchtime=3
#          set noshowmode
#          set noshowcmd
#          filetype plugin on
#
#          highlight Normal ctermbg=none guibg=NONE
#          highlight NonText ctermbg=none guibg=NONE
#          highlight LineNr ctermbg=none guibg=NONE
#          highlight Folded ctermbg=none guibg=NONE
#          highlight EndOfBuffer ctermbg=none guibg=NONE
#        ''
#          # Grep
#        ''
#          set ignorecase
#          set smartcase
#          set wrapscan
#          set hlsearch
#          set incsearch
#          set inccommand=split
#        ''
#            # Indent
#        ''
#          "set smartindent
#          "set expandtab
#          "set tabstop=2
#          "set softtabstop=1
#          "set shiftwidth=4
#        ''
#          # Auto Complete
#        ''    
#          set completeopt=noinsert,menuone,noselect
#          set wildmode=list:longest
#          set infercase
#          "set wildmenu
#        ''
#          # Other
#        ''    
#          "set mouse=a
#          "set clipboard+=unnamedplus
#          set backspace=indent,eol,start
#          set hidden
#          "set textwidth=300
#          set encoding=utf-8
#          "set nobackup
#          set nocompatible
#        ''
#      ];
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
