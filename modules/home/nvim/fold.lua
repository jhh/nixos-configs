vim.api.nvim_create_augroup("FileTypeFolds", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "htmldjango", "html" },
	callback = function()
		vim.opt_local.foldmethod = "indent"
		vim.opt_local.foldlevel = 99
	end,
	group = "FileTypeFolds",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.opt_local.foldmethod = "expr"
		vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
		vim.opt_local.foldlevel = 99
	end,
	group = "FileTypeFolds",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
		vim.opt_local.foldmethod = "expr"
		vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
		vim.opt_local.foldlevel = 99
	end,
	group = "FileTypeFolds",
})
