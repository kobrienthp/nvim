return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      -- one of these for icons:
      "nvim-tree/nvim-web-devicons", -- or 'nvim-mini/mini.icons'
    },
    ft = { "markdown" }, -- and 'quarto', 'rmarkdown', etc. if you like
    opts = {
      -- You can leave this empty to start; defaults are sane.
      -- Example: minimal tweaks
      heading = {
        icons = { "󰼏 ", "󰼐 ", "󰼑 ", "󰎲 ", "󰎯 ", "󰎴 " },
        border = true,
      },
      code = {
        border = "thin",
      },
    },
  },
}
