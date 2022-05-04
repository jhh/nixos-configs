-- neovim configuration
--

local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local map = vim.api.nvim_set_keymap
local o = vim.opt

-- colors --
o.termguicolors = false
o.background = "dark" -- or "light" for light mode
-- cmd([[colorscheme nord]])

-- basic Vim config --
o.scrolloff = 10 -- keep a minimum of 10 lines around cursor
o.linebreak = true -- soft wraps on words not individual chars
o.updatetime = 500
o.autochdir = false
o.autowrite = true

o.backspace = "indent,eol,start" -- backspace over all things
-- o.shell = '/run/current-system/sw/bin/fish'
o.viewoptions = "folds,options,cursor,unix,slash"
o.encoding = "utf-8"
o.number = true
o.relativenumber = true

local tabWidth = 2

o.expandtab = true
o.laststatus = tabWidth
o.tabstop = tabWidth
o.softtabstop = tabWidth
o.shiftwidth = tabWidth
