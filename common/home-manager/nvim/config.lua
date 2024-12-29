vim.opt.tabstop = 2 -- Number of spaces a <Tab> counts for
vim.opt.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.softtabstop = 2 -- Number of spaces a <Tab> counts for while editing
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.cmd([[colorscheme tokyonight-night]])

require("mini.basics").setup({
	basic = true,
	extra_ui = true,
	win_borders = "bold",
})
require("mini.icons").setup()
require("mini.notify").setup()
require("mini.pairs").setup()
require("mini.statusline").setup()
require("mini.starter").setup()
require("mini.surround").setup()

require("telescope").setup()
require("telescope").load_extension("fzf")

local wk = require("which-key")
wk.add({
	{ "<leader>f", group = "find" },
	{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
	{ "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
	{ "<leader>fe", "<cmd>Telescope file_browser path=%:p:h<cr>", desc = "File Browser" },
	{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Files" },
	{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
	{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
	{ "<leader>fm", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
	{ "<leader>fr", "<cmd>Telescope git_files<cr>", desc = "Git Files (repo)" },
	{ "<leader>ft", "<cmd>Telescope treesitter<cr>", desc = "Treesitter Symbols" },
	{ "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Current Buffer" },
	--
	{ "<leader>g", group = "git" },
	{ "<leader>gb", "<cmd>Telescope git_bcommits<cr>", desc = "Buffer Commits" },
	{ "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Commits" },
	{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
	{ "<leader>gl", "<cmd>Telescope git_branches<cr>", desc = "Branches (log)" },
	{ "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Status" },
	--
	{ "gs", "<cmd>Telescope grep_string<cr>", desc = "Find string under cursor" },
  --
  { "<leader>d", "<plug>DashSearch", desc = "Dash Search" },
})

require("nvim-treesitter.configs").setup({})

--
-- Formatter
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
    }
	},
})

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
augroup("__formatter__", { clear = true })
autocmd("BufWritePost", {
	group = "__formatter__",
	command = ":FormatWrite",
})

--
-- LSP
--
vim.lsp.config["nil"] = {
	cmd = { "nil" },
	filetypes = { "nix" },
	root_markers = { "flake.nix" },
}

vim.lsp.config["luals"] = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".git" },
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
				},
			},
		},
	},
}

vim.lsp.config["ruff"] = {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml" },
}

vim.lsp.enable("nil")
vim.lsp.enable("luals")
vim.lsp.enable("ruff")
