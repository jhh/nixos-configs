vim.opt.tabstop = 4 -- Number of spaces a <Tab> counts for
vim.opt.shiftwidth = 4 -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.softtabstop = 4 -- Number of spaces a <Tab> counts for while editing
vim.opt.scrolloff = 4 -- Number of lines to keep above and below the cursor
-- line numbers
vim.wo.number = true
vim.wo.relativenumber = true

-- center on vertical movement
vim.cmd.nnoremap("<C-d>", "<C-d>zz")
vim.cmd.nnoremap("<C-u>", "<C-u>zz")
vim.cmd.nnoremap("n", "nzz")
vim.cmd.nnoremap("N", "Nzz")

vim.cmd.xnoremap("<leader>p", '"_dP')
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("i", "jk", "<Esc>", { silent = true })
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.cmd("colorscheme tokyonight-night")

require("mini.ai").setup()
require("mini.bracketed").setup()
require("mini.diff").setup()
require("mini.git").setup()
require("mini.icons").setup()
require("mini.notify").setup()
require("mini.pairs").setup()
require("mini.statusline").setup()
require("mini.starter").setup()
require("mini.surround").setup()
require("mini.tabline").setup()
require("mini.basics").setup({
	basic = true,
	extra_ui = true,
	win_borders = "bold",
})
require("tailwind-tools").setup({})
require("nvim-treesitter.configs").setup({})
require("oil").setup()
