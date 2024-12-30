--
-- Telescope configuration
--
local telescope = require("telescope")
telescope.setup()
telescope.load_extension("fzf")

local wk = require("which-key")
wk.setup({
	preset = "modern",
	delay = 500,
})

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
	{ "<leader>e", group = "editor" },
	{ "<leader>ea", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "LSP code action" },
	{ "<leader>eu", "<cmd>Telescope undo<cr>", desc = "undo history" },
	{ "<leader>ed", "<plug>DashSearch", desc = "Dash Search" },
	--
	{ "gs", "<cmd>Telescope grep_string<cr>", desc = "Find string under cursor" },
	--
})
