vim.api.nvim_create_augroup("FileTypeFolds", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "htmldjango", "html" },
	callback = function()
		vim.opt_local.foldmethod = "indent"
	end,
	group = "FileTypeFolds",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.opt_local.foldmethod = "expr"
		vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
	end,
	group = "FileTypeFolds",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
		vim.opt_local.foldmethod = "expr"
		vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
	end,
	group = "FileTypeFolds",
})
