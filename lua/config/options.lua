-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--vim.opt.winbar = "%=%m %f"
vim.opt.scrolloff = 999
vim.g.snacks_animate = false
vim.opt.conceallevel = 0
vim.cmd([[autocmd FileType * set formatoptions-=ro]])
vim.opt.termguicolors = true
