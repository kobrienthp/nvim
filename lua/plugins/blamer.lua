return {
  {
    "APZelos/blamer.nvim",
    -- lazy-load on a sensible event, e.g. when entering a buffer:
    event = "BufReadPost",
    config = function()
      -- enable the plugin
      vim.g.blamer_enabled = true

      -- (optional) tune settings
      vim.g.blamer_delay = 500
      vim.g.blamer_show_in_visual_modes = 0
      vim.g.blamer_show_in_insert_modes = 0
      -- etc.
    end,
  },
}
