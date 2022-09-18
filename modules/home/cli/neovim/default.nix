{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.cli.neovim;
in
{
  options.modules.cli.neovim = {
    enable = mkOption {
      description = "Enable Neovim package";
      type = types.bool;
      default = true;
    };
  };

  config = mkIf (cfg.enable) {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      plugins = with pkgs.vimPlugins; [
        vimwiki
        vimagit
        vim-latex-live-preview
        vim-speeddating 
        vim-polyglot

        # UI & Themes
        nerdtree
        vim-nerdtree-syntax-highlight
        gruvbox-material
        vim-airline
        colorizer
        #nvim-web-devicons

          # Language servers
        vim-nix

          # Code formatting
        neoformat

          # Quality of life
        #indentLine
        vim-illuminate
        # auto-pairs # or coc-pairs
        quick-scope
        rainbow
        vim-orgmode
        telescope-nvim
        vim-clap
  
          # coc
        coc-clangd
        coc-python
        coc-prettier
        coc-pairs
      ];

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
  
      extraConfig = lib.strings.concatStringsSep "\n" [
        ''
          let mapleader =","
    
            " Disables automatic commenting on newline:
          autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
    
            " Perform dot commands over visual blocks:
          vnoremap . :normal .<CR>
    
            " Spell-check set to <leader>o:
          map <leader>oe :setlocal spell! spelllang=en_us<CR>
          map <leader>of :setlocal spell! spelllang=fr<CR>
    
            " Splits open at the bottom and right.
          set splitbelow splitright

            " split navigation:
    	    map <C-h> <C-w>h
    	    map <C-j> <C-w>j
    	    map <C-k> <C-w>k
    	    map <C-l> <C-w>l

          autocmd BufWritePost $XDG_CONFIG_HOME/x11/xresources silent exec "!xrdb $XDG_CONFIG_HOME/x11/xresources"
        ''
          # Plugins config
        ''    
            " Nerd tree
        	map <leader>n :NERDTreeToggle<CR>
    	    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
            if has('nvim')
              let NERDTreeBookmarksFile = stdpath('data') . '/NERDTreeBookmarks'
            else
              let NERDTreeBookmarksFile = '~/.vim' . '/NERDTreeBookmarks'
            endif
        ''
          # Custom Fontions
        ''    
            " Save file as sudo on files that require root permission
          cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
    
            " Check file in shellcheck:
    	    map <leader>s :!clear && shellcheck -x %<CR>
    
            " Compile document, be it groff/LaTeX/markdown/etc.
    	    map <leader>c :w! \| !compiler "<c-r>%"<CR>
    
            " Ensure files are read as what I want:
          let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
          map <leader>v :VimwikiIndex<CR>
          let g:vimwiki_list = [{'path': '~/.local/share/nvim/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
          autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
          autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
          autocmd BufRead,BufNewFile *.tex set filetype=tex

        ''
          # Gruvbox-Material Theme
        ''  
          " Gruvbox-Material
            " Available values: 'hard', 'medium'(default), 'soft'
          let g:gruvbox_material_background = 'medium'
          let g:gruvbox_material_transparent_background = 1
          colorscheme gruvbox-material
        ''
          # Visual
        ''
          set title
          set termguicolors
          set background=dark
          set number relativenumber
          set noruler
          set wrap
          set showmatch
          set matchtime=3
          set noshowmode
          set noshowcmd
          filetype plugin on
          let g:rainbow_active = 1

          highlight Normal ctermbg=none guibg=NONE
          highlight NonText ctermbg=none guibg=NONE
          highlight LineNr ctermbg=none guibg=NONE
          highlight Folded ctermbg=none guibg=NONE
          highlight EndOfBuffer ctermbg=none guibg=NONE
        ''
          # Grep
        ''
          set ignorecase
          set smartcase
          set wrapscan
          set hlsearch
          set incsearch
          set inccommand=split
        ''
            # Indent
        ''
          set smartindent
          set expandtab
          set tabstop=2
          set softtabstop=1
          set shiftwidth=4
        ''
          # Auto Complete
        ''    
          set completeopt=noinsert,menuone,noselect
          set wildmode=list:longest
          set infercase
          set wildmenu
        ''
          # Other
        ''    
          set mouse=a
          set clipboard+=unnamedplus
          set backspace=indent,eol,start
          set hidden
          set textwidth=300
          set encoding=utf-8
          set nobackup
          set nocompatible
        ''
      ];
    };
  
    home.packages = with pkgs; [ rnix-lsp ];
  };
}
