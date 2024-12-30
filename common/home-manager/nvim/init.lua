vim.opt.tabstop = 2 -- Number of spaces a <Tab> counts for
vim.opt.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.softtabstop = 2 -- Number of spaces a <Tab> counts for while editing
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.cmd([[colorscheme tokyonight-night]])

require("mini.ai").setup()
require("mini.bracketed").setup()
require("mini.git").setup()
require("mini.icons").setup()
require("mini.notify").setup()
require("mini.pairs").setup()
require("mini.statusline").setup()
require("mini.starter").setup()
require("mini.surround").setup()
require("mini.basics").setup({
	basic = true,
	extra_ui = true,
	win_borders = "bold",
})

-- Get the current MANPATH from the shell
-- local current_manpath = vim.fn.system("manpath -q"):gsub("%s+$", "")

-- Add Nix manpaths
-- local nix_manpath = vim.fn.system("nix-env -q --out-path | awk '{print $2 \"/share/man\"}' | tr '\\n' ':'"):gsub("%s+$", "")

-- Update MANPATH
-- vim.env.MANPATH = current_manpath -- .. ":" .. nix_manpath
