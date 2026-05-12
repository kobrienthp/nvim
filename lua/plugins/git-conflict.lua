return {
  {
    "akinsho/git-conflict.nvim",
    event = "VeryLazy", -- lazy-load on a low-priority event
    config = function()
      require("git-conflict").setup({
        default_mappings = true, -- set up default keymaps
        disable_diagnostics = false,
        highlights = {
          incoming = "DiffText",
          current = "DiffAdd",
        },
      })
    end,
    keys = {
      { "<leader>co", "<cmd>GitConflictChooseOurs<CR>", desc = "Choose Ours" },
      { "<leader>ct", "<cmd>GitConflictChooseTheirs<CR>", desc = "Choose Theirs" },
      { "<leader>cb", "<cmd>GitConflictChooseBoth<CR>", desc = "Choose Both" },
      { "<leader>cn", "<cmd>GitConflictNextConflict<CR>", desc = "Next Conflict" },
      { "<leader>cp", "<cmd>GitConflictPrevConflict<CR>", desc = "Prev Conflict" },
      { "<leader>cr", "<cmd>GitConflictResolve<CR>", desc = "Resolve Conflict" },
    },
  },
}
