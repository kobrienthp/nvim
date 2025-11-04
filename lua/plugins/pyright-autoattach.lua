return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      -- Auto-start Pyright for any Python buffer inside your workspace
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
        pattern = "*.py",
        callback = function(args)
          local bufnr = args.buf
          -- If Pyright is not attached to this buffer, start it.
          if #vim.lsp.get_clients({ bufnr = bufnr, name = "pyright" }) == 0 then
            vim.cmd("LspStart pyright")
          end
        end,
      })
    end,
  },
}
