----------------------------------
-- nvim-tree
----------------------------------

-- Empty setup using defaults
require('nvim-tree').setup()

-- Keybindings
vim.keymap.set('n', '<leader>n', '<Cmd>NvimTreeToggle<CR>', { desc = "Open file tree" })
