return {
  {
    "linux-cultist/venv-selector.nvim",
    cmd = { "VenvSelect", "VenvSelectCached" },
    opts = {
      settings = {
        search = {
          -- auto-detect .venv, uv venvs, pyenv, etc.
          venv_managers = { "uv", "poetry", "pipenv", "pyenv", "virtualenvwrapper", "hatch", "conda", "venv" },
        },
      },
      auto_refresh = true,
    },
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select virtualenv" },
      { "<leader>cV", "<cmd>VenvSelectCached<cr>", desc = "Re-select last venv" },
    },
  },
}
