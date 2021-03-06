-- https://github.com/folke/which-key.nvim
--
local wk = require("which-key")

wk.setup({})

wk.register({
	f = {
		name = "Find", -- optional group name
		b = { "<cmd>Telescope buffers<cr>", "Buffers" },
		c = { "<cmd>Telescope commands<cr>", "Commands" },
		e = { "<cmd>Telescope file_browser<cr>", "File Browser" },
		f = { "<cmd>Telescope find_files<cr>", "Files" },
		g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
		h = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
		m = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
		r = { "<cmd>Telescope git_files<cr>", "Git Files (repo)" },
		t = { "<cmd>Telescope treesitter<cr>", "Treesitter Symbols" },
		z = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Current Buffer" },
	},
	g = {
		name = "Git",
		b = { "<cmd>Telescope git_bcommits<cr>", "Buffer Commits" },
		c = { "<cmd>Telescope git_commits<cr>", "Commits" },
		g = { "<cmd>LazyGit<cr>", "LazyGit" },
		l = { "<cmd>Telescope git_branches<cr>", "Branches (log)" },
		s = { "<cmd>Telescope git_status<cr>", "Status" },
	},
	-- Tabs
	t = {
		name = "Tabs",
		n = { "<Cmd>tabnew +term<CR>", "New with terminal" },
		o = { "<Cmd>tabonly<CR>", "Close all other" },
		q = { "<Cmd>tabclose<CR>", "Close" },
		l = { "<Cmd>tabnext<CR>", "Next" },
		h = { "<Cmd>tabprevious<CR>", "Previous" },
	},
	z = { "<cmd>nohlsearch<cr>", "Clear Search" },
}, {
	prefix = "<space>",
})

wk.register({
	g = {
		s = { "<cmd>Telescope grep_string<cr>", "Find string under cursor" },
	},
}, {})

wk.register({
	t = {
		name = "Test", -- optional group name
		n = { "<cmd>TestNearest<cr>", "Nearest" },
		f = { "<cmd>TestFile<cr>", "File" },
		s = { "<cmd>TestSuite<cr>", "Suite" },
		l = { "<cmd>TestLast<cr>", "Last" },
		v = { "<cmd>TestVisit<cr>", "Visit" },
	},
}, {})
