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

      coc = {
        enable = true;
        pluginConfig = ''
          nmap <silent> <space><space> :<C-u>call CocAction('doHover')<cr>
          " go back from definition is C-O
          nmap <silent> <space>d <Plug>(coc-definition)
          nmap <silent> <space>r <Plug>(coc-references)
          nmap <silent> <space>n <Plug>(coc-rename)
          nmap <silent> <space>f <Plug>(coc-format)

          function! CheckBackspace() abort
            let col = col('.') - 1
            return !col || getline('.')[col - 1]  =~# '\s'
          endfunction

          " Use <Tab> and <S-Tab> to navigate the completion list
          inoremap <silent><expr> <TAB>
                \ pumvisible() ? "\<C-n>" :
                \ CheckBackspace() ? "\<TAB>" :
                \ coc#refresh()
          inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

          let g:coc_user_config = {
            \"suggest.completionItemKindLabels": {
              \"class": "\uf0e8",
              \"color": "\ue22b",
              \"constant": "\uf8ff",
              \"default": "\uf29c",
              \"enum": "\uf435",
              \"enumMember": "\uf02b",
              \"event": "\ufacd",
              \"field": "\uf93d",
              \"file": "\uf471",
              \"folder": "\uf115",
              \"function": "\uf794",
              \"interface": "\ufa52",
              \"keyword": "\uf893",
              \"method": "\uf6a6",
              \"operator": "\uf915",
              \"property": "\ufab6",
              \"reference": "\uf87a",
              \"snippet": "\uf64d",
              \"struct": "\ufb44",
              \"text": "\ue612",
              \"typeParameter": "\uf278",
              \"unit": "\uf475",
              \"value": "\uf8a3",
              \"variable": "\uf71b"
            \}
          \}
        '';

        # $XDG_CONFIG_HOME/nvim/coc-settings.json
        settings = {
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

      plugins = with pkgs.vimPlugins; [
        gruvbox-material
        vim-nix
        vifm-vim
        vimwiki
        vimagit
        rainbow
        nvim-web-devicons
        # auto-pairs # or coc-pairs
        nerdtree
        vim-airline
  #      vim-css-color
        colorizer
        vim-latex-live-preview
        vim-polyglot
  
        # coc
        coc-json
        coc-yaml
        coc-html
        coc-clangd
        coc-python
        coc-tsserver
        coc-eslint
        coc-pairs # or auto-pairs
        coc-prettier
      ];
  
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
    
            " Run xrdb whenever Xdefaults or Xresources are updated.
          autocmd BufRead,BufNewFile Xresources,Xdefaults,xresources,xdefaults set filetype=xdefaults
          autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults !xrdb %

            " Check file in shellcheck:
    	    map <leader>s :!clear && shellcheck -x %<CR>
    
            " Compile document, be it groff/LaTeX/markdown/etc.
    	    map <leader>c :w! \| !compiler "<c-r>%"<CR>
    
            " Open corresponding .pdf/.html or preview
    	    map <leader>p :!opout <c-r>%<CR><CR>
    
            " Runs a script that cleans out tex build files whenever I close out of a .tex file.
    	    autocmd VimLeave *.tex !texclear %
    
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
