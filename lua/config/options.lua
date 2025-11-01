-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--vim.opt.winbar = "%=%m %f"
vim.g.snacks_animate = false
vim.opt.conceallevel = 0
vim.cmd([[autocmd FileType * set formatoptions-=ro]])
vim.opt.termguicolors = true

-- Basic settings
vim.opt.clipboard = "unnamedplus"
--vim.opt.background = "dark"

vim.opt.autoread = true
vim.opt.backup = false
vim.opt.writebackup = false

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.wrap = true
vim.opt.cursorline = true
vim.opt.ruler = true
vim.opt.scrolloff = 999

-- Enable syntax highlighting (redundant in LazyVim, but safe)
vim.cmd("syntax enable")
