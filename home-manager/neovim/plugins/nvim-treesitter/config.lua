----------------------------------
-- nvim-treesitter
----------------------------------

require('nvim-treesitter.configs').setup({

  -- A list of parser names, or "all"
  ensure_installed = all,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  -- Change install location for parsers
  parser_install_dir = "~/.local/share/nvim/nvim-treesitter",

  -- Enable syntax highlighting
  highlight = {
      enable = true,
      additional_vim_regex_highlighting = {'org'},
  },

  -- Ensure parser location added to path
  vim.opt.runtimepath:append("~/.local/share/nvim/nvim-treesitter")
})
