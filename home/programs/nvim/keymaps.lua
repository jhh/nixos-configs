local wk = require("which-key")

wk.register({
  f = {
    name = "File", -- optional group name
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File"}
  },
  g = {
    name = "Git",
    g = { "<cmd>LazyGit<cr>", "LazyGit"},
  },
}, { prefix = "<leader>" })
