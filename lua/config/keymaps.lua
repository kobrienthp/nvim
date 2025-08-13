-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
-- Normal mode: Shift-Tab dedents the current line
--vim.keymap.set("n", "<S-Tab>", "<<", { desc = "Dedent line" })

-- Insert mode: Shift-Tab sends Ctrl-d to delete one indent level
vim.keymap.set("i", "<S-Tab>", "<C-d>", { desc = "Delete indent" })

vim.keymap.set("n", "Y", "yy", { desc = "Yank line" })

vim.keymap.set("n", "<C-a>l", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<C-a>j", "<C-w>s", { desc = "Split window horizontally" })

for i = 0, 6 do
  local lhs = "<leader>" .. i
  local rhs = (i + 1) .. "<c-w>w"
  vim.keymap.set("n", lhs, rhs, { desc = "Move to window " .. i })
end
vim.keymap.set("n", "<C-0>", "1<c-w>w", { desc = "Move to window 0" })
vim.keymap.del({ "n", "s" }, "<C-b>")

vim.keymap.set("n", "s", "cl")

-- Buffer navigation
vim.keymap.set("n", "<Tab>", vim.cmd.bnext)
vim.keymap.set("n", "<S-Tab>", vim.cmd.bprev)

vim.keymap.set({ "n" }, "<C-`>", function()
  Snacks.terminal(nil, { cwd = LazyVim.root(), win = { position = "bottom" } })
end, { desc = "Terminal (Root Dir)" })
vim.keymap.set({ "t" }, "<C-`>", "<C-\\><C-n>")

vim.keymap.set({ "n", "v", "o" }, "'", "<Nop>", { noremap = true, silent = true, nowait = true })
vim.keymap.set({ "n", "v", "o" }, "`", "<Nop>", { noremap = true, silent = true, nowait = true })
local wk = require("which-key")
wk.add({
  { "'", mode = { "n", "v", "o" }, hidden = true },
  { "`", mode = { "n", "v", "o" }, hidden = true },
})
