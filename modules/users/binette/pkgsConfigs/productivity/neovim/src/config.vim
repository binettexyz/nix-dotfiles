lua << EOF

----------------------------------
-- General
----------------------------------

-- Visual
vim.opt.background = "dark"
vim.opt.fillchars = {eob = ' '} -- Also prevent '~' from showing on blank lines
vim.opt.matchtime = 3
--vim.opt.ruler = false
vim.opt.number = true           -- Relative line numbers
vim.opt.relativenumber = true
vim.opt.showcmd = false
vim.opt.showmode = false
vim.opt.showmatch = true        -- Show matching parenthesis
vim.opt.signcolumn = "yes"      -- Always show the signcolumn
vim.opt.syntax = "on"
vim.opt.termguicolors = true
vim.opt.textwidth = 0
vim.opt.title = true            -- Make terminal title same as the file
vim.opt.wrap = true             -- Enable line wrap
vim.opt.linebreak = true        -- Wrapped lines break at word boundaries
vim.opt.wrapmargin = 0

-- Grep
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrapscan = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = "split"

-- Make sure swap and backup files are created
vim.opt.backup = true
vim.opt.swapfile = false
vim.opt.directory = os.getenv("HOME") .. "/.local/share/nvim/swap"
vim.opt.backupdir = os.getenv("HOME") .. "/.local/share/nvim/backup"

-- Indent
vim.opt.tabstop = 2           -- display tabs as 2 spaces (if expandtab is off)
vim.opt.shiftwidth = 2        -- auto-indent uses 2 spaces
vim.opt.softtabstop = 2       -- <Tab> inserts 2 spaces
vim.opt.expandtab = true      -- use spaces instead of tabs
vim.opt.smartindent = true

-- Autocomplete
vim.opt.wildmenu = true
vim.opt.wildmode = {'longest', 'list', "full"}
vim.opt.infercase = true

-- Other
vim.opt.backspace = {'indent', 'eol', 'start'}
vim.opt.encoding = "utf-8"
vim.opt.hidden = true
vim.opt.mouse = "a" -- Enable mouse control
vim.opt.shortmess = vim.o.shortmess .. "c" -- Ignores all the 'hit-enter' prompts
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.clipboard:append { "unnamed", "unnamedplus" } -- Use clipboard register



----------------------------------
-- Keybindings
----------------------------------

-- Set leader key to space
vim.g.mapleader = ","

-- Perform dot commands over visual blocks
vim.cmd('vnoremap . :normal .<CR>')

-- Reload neovim config
vim.keymap.set("n", "<leader><S-BS>", ":so ~/.config/nvim/init.lua<CR>", { desc="Reload config" })

-- Compile document, be it groff/LaTeX/markdown/etc
vim.keymap.set("n", "<leader>c", ":w! | !compiler '%:p'<CR>", { desc="Compile document, be it groff/LaTeX/markdown/etc" })

-- Open corresponding .pdf/.html or preview
vim.keymap.set("n", "<leader>p", ":!opout '%:p'<CR>", { desc="Open corresponding .pdf/.html or preview" })

-- Keep cursor in middle of screen when half-page-jumping
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc="Half-page up" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc="Half-page down" })

-- Set up text replacement macro
vim.keymap.set("n", "<leader>S", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc="Substitute" })

-- Spell-check set to <leader>o:
vim.keymap.set("n", "<leader>oe", ":setlocal spell! spelllang=en_us<CR>", { desc="Spell-check english" })
vim.keymap.set("n", "<leader>of", ":setlocal spell! spelllang=fr<CR>", { desc="Spell-check french" })

-- Split naviguation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Goyo toggle
vim.keymap.set("n", "<leader>z", ":Goyo<CR>", { desc = "Toggle Zen mode" })

----------------------------------
-- Colorscheme
----------------------------------

local ok, _ = pcall(vim.cmd, 'colorscheme <COLOURSCHEME>')
if not ok then
  vim.cmd 'colorscheme default'
end

----------------------------------
-- Plugin-preparation
----------------------------------

-- nvim-tree: Disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

----------------------------------
-- Filetype-specific
----------------------------------

-- Markdown
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt.spell = true
    vim.opt.textwidth = 80
    vim.opt_local.spelllang = { "en" }
  end
})

EOF
