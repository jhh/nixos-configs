vim.opt.tabstop = 2 -- Number of spaces a <Tab> counts for
vim.opt.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.softtabstop = 2 -- Number of spaces a <Tab> counts for while editing
vim.opt.scrolloff = 2 -- Number of lines to keep above and below the cursor
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

vim.cmd("colorscheme tokyonight")

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"
vim.opt.foldenable = false -- Enable folding by default

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

-- Get the current MANPATH from the shell
-- local current_manpath = vim.fn.system("manpath -q"):gsub("%s+$", "")

-- Add Nix manpaths
-- local nix_manpath = vim.fn.system("nix-env -q --out-path | awk '{print $2 \"/share/man\"}' | tr '\\n' ':'"):gsub("%s+$", "")

-- Update MANPATH
-- vim.env.MANPATH = current_manpath -- .. ":" .. nix_manpath
