return {
  { "navarasu/onedark.nvim" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
  --lazy = false,
  --priority = 1000,
  --config = function()
  --  require("onedark").setup({
  --    style = "dark",
  --  })
  --  require("onedark").load()
  --end,
}
