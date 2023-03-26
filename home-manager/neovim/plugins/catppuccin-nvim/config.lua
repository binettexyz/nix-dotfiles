----------------------------------
-- catppuccin-nvim
----------------------------------

require('catppuccin').setup({

  flavor = "mocha",

  transparent_background = true,

  -- show the '~' characters after the end of buffers
  show_end_of_buffer = false,

  color_overrides = {
	  mocha = {
	    base = "#181825",
		  mantle = "#181825",
		  crust = "#181825",
		},
  },

  integrations = {
    coc_nvim = true,
  },

})

--vim.cmd.colorscheme "catppuccin"
