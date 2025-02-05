--
-- Formatter configuration
--
require("formatter").setup({
	filetype = {
		lua = {
			require("formatter.filetypes.lua").stylua,
		},
		nix = {
			require("formatter.filetypes.nix").nixfmt,
		},
		python = {
			require("formatter.filetypes.python").ruff,
		},
	},
})

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
augroup("__formatter__", { clear = true })
autocmd("BufWritePost", {
	group = "__formatter__",
	command = ":FormatWrite",
})
