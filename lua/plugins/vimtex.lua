return {
  "lervag/vimtex",
  lazy = false, -- lazy-loading will disable inverse search
  config = function()
    vim.g.vimtex_view_method = "sioyek"
    vim.g.vimtex_compiler_latexmk = {
      aux_dir = "./.latexmk/aux",
      out_dir = "./.latexmk/out",
      executable = "latexmk",
      options = {
        "-pdf",
        "-verbose",
        "-bibtex", -- force a BibTeX run
        "-file-line-error",
        "-synctex=1",
        "-interaction=nonstopmode",
      },
    }
  end,
  keys = {
    { "<localLeader>l", "", desc = "+vimtex" },
  },
}
