-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_set_option("clipboard", "unnamed")

-- LaTeX: use 2 spaces instead of 4
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tex", "latex" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})
vim.g.autoformat = true

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.b.autoformat = true
  end,
})

-- Enforce exactly one trailing *blank* line in Python files, robustly.
-- Works even if other formatters/whitespace trimmers run on BufWritePre.
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    local grp = vim.api.nvim_create_augroup("EnsurePyBlankEOF_PostWrite", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = grp,
      pattern = "*.py",
      callback = function(args)
        if vim.b.__fixing_py_blank_eof then
          return
        end

        local bufnr = args.buf
        local function getline(i)
          return vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1] or ""
        end

        local n = vim.api.nvim_buf_line_count(bufnr)
        if n == 0 then
          return
        end

        local changed = false

        -- Collapse multiple trailing empty lines to at most one
        while n > 1 and getline(n) == "" and getline(n - 1) == "" do
          vim.api.nvim_buf_set_lines(bufnr, n - 1, n, false, {})
          n = n - 1
          changed = true
        end

        -- Ensure the last line is empty (one blank line at EOF)
        if getline(n) ~= "" then
          vim.api.nvim_buf_set_lines(bufnr, n, n, false, { "" })
          n = n + 1
          changed = true
        end

        -- Also make sure a final newline is written
        if vim.bo[bufnr].endofline == false or vim.bo[bufnr].fixendofline == false then
          vim.bo[bufnr].endofline = true
          vim.bo[bufnr].fixendofline = true
          changed = true
        end

        if changed then
          -- Prevent recursion, and write without triggering other autocmds
          vim.b.__fixing_py_blank_eof = true
          vim.cmd("noautocmd write")
          vim.b.__fixing_py_blank_eof = false
        end
      end,
      desc = "Force exactly one trailing blank line (Python) after write",
    })
  end,
})
