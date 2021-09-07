-- https://github.com/folke/which-key.nvim
--
local wk = require("which-key")

wk.setup { }

wk.register({
  f = {
    name = "Find", -- optional group name
    b = { "<cmd>Telescope buffers<cr>", "Find Buffer" },
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
    h = { "<cmd>Telescope help_tags<cr>", "Find Help Tag" },
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File"}
  },
  g = {
    name = "Git",
    g = { "<cmd>LazyGit<cr>", "LazyGit"},
  },
  -- Tabs
  t = {
    name = '+Tabs',
    n = { '<Cmd>tabnew +term<CR>'  , 'New with terminal' },
    o = { '<Cmd>tabonly<CR>'       , 'Close all other'   },
    q = { '<Cmd>tabclose<CR>'      , 'Close'             },
    l = { '<Cmd>tabnext<CR>'       , 'Next'              },
    h = { '<Cmd>tabprevious<CR>'   , 'Previous'          },
  },
  z = { "<cmd>nohlsearch<cr>", "Clear Search" },
}, { prefix = " " })

