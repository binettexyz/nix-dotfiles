{
  flake,
  pkgs,
  ...
}:
let
  cocConfig = {
    coc.preferences = {
      formatOnSave = true;
      formatOnType = true;
    };

    suggest = {
      noselect = true;
      enablePreview = true;
      enablePreselect = false;
    };

    colors.enable = true;

    nixd.formattingCommand = [ "${pkgs.nixfmt}/bin/nixfmt" ];

    languageserver.nix = {
      command = "${pkgs.nixd}/bin/nixd";
      filetypes = [ "nix" ];
      rootpatterns = [ "flake.nix" ];
    };
  };
in
{
  imports = [
    flake.inputs.nixvim.homeModules.nixvim
  ];

  home.packages = [
    pkgs.nodejs
    pkgs.nixd
    pkgs.nixfmt
  ];

  xdg.configFile = {
    "nvim/coc-settings.json" = {
      source = pkgs.writeText "coc-settings.json" (builtins.toJSON cocConfig);
    };
  };

  programs.nixvim = {
    enable = true;
    colorschemes.gruvbox-material = {
      enable = true;
      settings = {
        background = "hard";
        transparent_background = 1;
      };
    };

    clipboard = {
      # Use system clipboard
      register = "unnamedplus";
      providers = {
        wl-copy = {
          enable = true;
          package = pkgs.wl-clipboard;
        };
      };
    };

    performance = {
      byteCompileLua = {
        enable = true;
        nvimRuntime = true;
        configs = true;
        plugins = true;
      };
    };

    opts = {
      background = "dark";
      matchtime = 3;
      ruler = false;
      showmode = false;
      showmatch = true; # Show matching parenthesis
      textwidth = 0;
      title = true;
      syntax = "enable";

      showcmd = true;
      cmdheight = 0;

      # Enable relative line numbers
      number = true;
      relativenumber = true;

      # Enable 24-bit colors
      termguicolors = true;

      # Enable the sign column to prevent the screen from jumping
      signcolumn = "yes";

      # Enable cursor line highlight
      cursorline = true; # Highlight the line where the cursor is located

      # Enable text wrap
      wrap = true;
      wrapmargin = 0;
      wrapscan = true;

      # Enable ignorecase + smartcase for better searching
      ignorecase = true;
      smartcase = true;

      # Enable incremental searching
      hlsearch = true;
      incsearch = true;

      # Enable persistent undo history
      swapfile = false;
      autoread = true;
      backup = false;
      undofile = true;

      # Set tabs to 2 spaces
      tabstop = 2;
      softtabstop = 2;
      showtabline = 0;
      expandtab = true;

      # Enable smart indenting (see https://stackoverflow.com/questions/1204149/smart-wrap-in-vim)
      breakindent = true;

      # Enable auto indenting and set it to spaces
      smartindent = true;
      shiftwidth = 2;

      # Better splitting
      splitbelow = true;
      splitright = true;

      # Enable mouse mode
      mouse = "a";

      # ---Autocomplete---
      wildmenu = true;
      wildmode = "longest,list,full";
      infercase = true;

      # Always keep 8 lines above/below cursor unless at start/end of file
      scrolloff = 10;

      # Reduce which-key timeout to 10ms
      timeoutlen = 10;

      # Set encoding type
      encoding = "utf-8";
      fileencoding = "utf-8";
      # ---others---
      backspace = "indent,eol,start";
      hidden = true;
      fillchars.eob = " "; # Prevent "~" from showing on blank lines
    };

    globals = {
      mapleader = ",";
    };

    extraConfigLua = ''
      -- Perform dot commands over viual blocks
      vim.cmd('vnoremap . :normal .<CR>')

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.opt.spell = true
          vim.opt.textwidth = 80
          vim.opt_local.spelllang = { "en" }
        end
      })
    '';

    extraConfigVim = '''';

    keymaps =
      let
        keymap =
          mode: key: action:
          {
            options ? { },
          }:
          {
            inherit
              mode
              key
              action
              options
              ;
          };
      in
      [
        (keymap "n" "<leader>R" ":%s/\<C-r><C-w>//g<Left><Left>" { }) # Search and replace word under cursor
        (keymap "n" "<leader>/" "<cmd>nohl<CR>" { }) # Clear Search
        (keymap "n" "<leader>f" "+find/file" { })
        (keymap "n" "<leader>s" "+search" { })
        (keymap "n" "<leader>q" "+quit/session" { })
        (keymap "n" "<leader>w" "+windows" { })
        (keymap "n" "<leader><tab>" "+tabs" { })
        # ---Tabs---
        (keymap "n" "<leader><tab><tab>" "<cmd>tabnew<cr>" {
          options = {
            silent = true;
            desc = "New Tab";
          };
        })
        (keymap "n" "<leader><tab>d" "<cmd>tabclose<cr>" {
          options = {
            silent = true;
            desc = "Close Tab";
          };
        })
        # ---Windows---
        (keymap "n" "<leader>ww" "<C-W>p" {
          options = {
            silent = true;
            desc = "Other Window";
          };
        })
        (keymap "n" "<leader>wd" "<C-W>c" {
          options = {
            silent = true;
            desc = "Delete Window";
          };
        })
        (keymap "n" "<leader>w-" "<C-W>s" {
          options = {
            silent = true;
            desc = "split window below";
          };
        })
        (keymap "n" "<leader>w|" "<C-W>v" {
          options = {
            silent = true;
            desc = "Split window right";
          };
        })
        (keymap "n" "<C-h>" "<C-W>h" {
          options = {
            silent = true;
            desc = "Move window to left";
          };
        })
        (keymap "n" "<C-l>" "<C-W>l" {
          options = {
            silent = true;
            desc = "Move window to right";
          };
        })
        (keymap "n" "<C-k>" "<C-W>k" {
          options = {
            silent = true;
            desc = "Move window over";
          };
        })
        (keymap "n" "<C-j>" "<C-W>j" {
          options = {
            silent = true;
            desc = "Move window below";
          };
        })
        (keymap "n" "<C-s>" "<cmd>w<cr><esc>" {
          options = {
            silent = true;
            desc = "Save file";
          };
        })
        # ---Quit/Session---
        (keymap "n" "<leader>qq" "<cmd>quitall<cr><esc>" {
          options = {
            silent = true;
            desc = "Quit all";
          };
        })
        (keymap "v" "J" ":m '>+1<CR>gv=gv" { options.desc = "Use move command when line is highlighted"; })
        (keymap "n" "<C-d>" "<C-d>zz" { options.desc = "Half page down"; })
        (keymap "n" "<C-u>" "<C-u>zz" { options.desc = "Half page up"; })
        (keymap "n" "n" "nzzzv" { }) # Allow search terms to stay in the middle
        (keymap "n" "N" "nzzzv" { }) # Allow search terms to stay in the middle
        # ---Void register---
        (keymap "x" "<leader>p" ''"_dP'' { }) # Deletes to void register and paste over
        (keymap [ "n" "v" ] "<leader>D" ''"_d'' { }) # Delete to void register
        # ---Others---
        (keymap "n" "<leader><S-BS>" ":so ~/.config/nvim/init.lua<CR>" { options.desc = "Reload config"; })
        (keymap "n" "<leader>c" ":w! | !compiler '%:p'<CR>" {
          options.desc = "Compile document, be it groff/LaTeX/markdown/etc";
        })
        (keymap "n" "<leader>oe" ":setlocal spell! spelllang=en_us<CR>" {
          options.desc = "Spell-check english";
        })
        (keymap "n" "<leader>of" ":setlocal spell! spelllang=fr<CR>" {
          options.desc = "Spell-check french";
        })
        (keymap "n" "<leader>n" "<Cmd>Neotree<CR>" { options.desc = "Open file tree"; })
      ];

    plugins = {
      notify.enable = true;
      web-devicons.enable = true;
      project-nvim.enable = true;
      telescope.enable = true;
      barbar.enable = true;
      gitgutter.enable = true;
      colorizer.enable = true;
      which-key.enable = true;
      illuminate.enable = true;
      nix.enable = true;
      alpha = {
        enable = true;
        theme = "dashboard";
      };
      trim = {
        enable = true;
        settings = {
          ft_blocklist = [ "coc-explorer" ];
          highlight = false;
        };
      };
      lualine = {
        enable = true;
        settings = {
          sections = {
            lualine_x = [
              "diagnostics"
              "encoding"
              "filetype"
            ];
          };
        };
      };
      treesitter = {
        enable = true;
        #        grammarPackages =
        #          let
        #            pkg = pkgs.vimPlugins.nvim-treesitter.builtGrammars;
        #          in
        #          [
        #            pkg.nix
        #          ];
        settings = {
          auto_install = true;
          ensure_installed = [ "nix" ];
          highlight = {
            enable = true;
          };
        };
      };
      vimwiki = {
        enable = true;
        settings = {
          global_ext = 0;
          table_mappings = 0;
          list = [
            {
              ext = ".md";
              path = "~/documents/notes";
              syntax = "markdown";
            }
          ];
        };
      };
      vimtex = {
        enable = true;
        settings = {
          view_method = "zathura";
          compiler_method = "latexrun";
        };
      };
      rainbow = {
        enable = true;
        settings = {
          active = 1;
        };
      };
      neo-tree = {
        enable = true;
        settings = {
          close_if_last_window = true;
          filesystem = {
            follow_current_file = {
              enabled = true;
              leave_dirs_open = true;
            };
          };
        };
      };
    };

    extraPlugins = [
      pkgs.vimPlugins.llm-nvim
      pkgs.vimPlugins.coc-nvim
      pkgs.vimPlugins.auto-pairs
      pkgs.vimPlugins.quick-scope
      pkgs.vimPlugins.vim-table-mode
    ];
  };
}
