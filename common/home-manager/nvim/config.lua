vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.cmd[[colorscheme tokyonight-night]]

require('mini.icons').setup()
require('mini.pairs').setup()
require('mini.statusline').setup()
require('mini.surround').setup()

require('telescope').setup()
require('telescope').load_extension('fzf')

local wk = require("which-key")
wk.add({
    {"<leader>f", group="find"},
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
    { "gs", "<cmd>Telescope grep_string<cr>", desc = "Find string under cursor" }
})

require('nvim-treesitter.configs').setup({

})
