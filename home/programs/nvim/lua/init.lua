-- neovim configuration
--

local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local map = vim.api.nvim_set_keymap
local o = vim.opt

-- basic Vim config --
o.scrolloff  = 10 -- keep a minimum of 10 lines around cursor
o.linebreak  = true -- soft wraps on words not individual chars
o.updatetime = 500
o.autochdir  = false

o.backspace = "indent,eol,start" -- backspace over all things
o.shell = '/run/current-system/sw/bin/fish'
o.viewoptions = 'folds,options,cursor,unix,slash'
o.encoding = 'utf-8'
o.number = true
o.relativenumber = true
o.termguicolors = true

local tabWidth = 2

o.expandtab = true
o.laststatus = tabWidth
o.tabstop = tabWidth
o.softtabstop = tabWidth
o.shiftwidth = tabWidth

