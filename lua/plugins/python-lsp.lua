return {
  -- Ensure tools are installed
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "pyright",
        "ruff",
        "debugpy",
      })
    end,
  },

  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Ruff: ultra-fast lints/fixes; let Pyright handle hover
        ruff_lsp = {
          on_attach = function(client, _)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
            client.server_capabilities.hoverProvider = false
          end,
        },

        -- Pyright: types, hover, jumps, rename, etc.
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic", -- or "strict"
                autoImportCompletions = true,
                useLibraryCodeForTypes = true,
                extraPaths = { "src" },
              },
            },
          },
        },
      },

      -- Custom setup so Pyright prefers a project-local .venv python
      setup = {
        pyright = function(_, opts)
          local util = require("lspconfig.util")
          opts.root_dir = util.root_pattern("pyproject.toml", "setup.cfg", "setup.py", "requirements.txt", ".git")

          opts.before_init = function(_, config)
            local uv = vim.uv or vim.loop
            local cwd = uv.cwd()
            local venv = nil
            local candidates = {
              cwd .. "/.venv/bin/python", -- Unix
              cwd .. "/.venv/Scripts/python.exe", -- Windows
            }
            for _, p in ipairs(candidates) do
              if vim.fn.executable(p) == 1 then
                venv = p
                break
              end
            end
            if venv then
              config.settings = config.settings or {}
              config.settings.python = config.settings.python or {}
              config.settings.python.pythonPath = venv
            end
          end

          require("lspconfig").pyright.setup(opts)
          return true -- tell LazyVim we handled setup
        end,
      },
    },
  },
}
