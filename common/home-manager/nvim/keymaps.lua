local wk = require("which-key")

wk.register({
	f = {
		name = "Find", -- optional group name
		b = { "<cmd>Telescope buffers<cr>", "Find Buffer" },
		f = { "<cmd>Telescope find_files<cr>", "Find File" },
		g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
		h = { "<cmd>Telescope help_tags<cr>", "Find Help Tag" },
		r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
	},
	g = {
		name = "Git",
		g = { "<cmd>LazyGit<cr>", "LazyGit" },
	},
}, {
	prefix = " ",
})
