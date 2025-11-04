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
        -- Disable the legacy ruff_lsp completely
        ruff_lsp = false,

        -- Use the modern "ruff" server for linting/quickfixes only
        ruff = {
          on_attach = function(client, _)
            -- Keep diagnostics and code actions from Ruff, but
            -- turn off features that should come from Pyright.
            client.server_capabilities.hoverProvider = false
            client.server_capabilities.definitionProvider = false
            client.server_capabilities.referencesProvider = false
            client.server_capabilities.typeDefinitionProvider = false
            client.server_capabilities.declarationProvider = false
            client.server_capabilities.implementationProvider = false
            client.server_capabilities.renameProvider = false
            -- Optional: if you don’t want Ruff to format
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
        },

        -- Pyright: types, hovers, jumps, rename, cross-file refs
        pyright = {
          single_file_support = false,
          settings = {
            python = {
              analysis = {
                diagnosticMode = "workspace",
                typeCheckingMode = "basic",
                autoImportCompletions = true,
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                extraPaths = { "src", "." }, -- adjust to your layout
              },
            },
          },
        },
      },

      -- Custom setup so Pyright prefers a project-local .venv python and stable roots
      setup = {
        pyright = function(_, opts)
          local util = require("lspconfig.util")
          opts.root_dir = util.root_pattern(
            "pyproject.toml",
            "pyrightconfig.json",
            "setup.cfg",
            "setup.py",
            "requirements.txt",
            ".git"
          )
          opts.single_file_support = false

          opts.before_init = function(_, config)
            local uv = vim.uv or vim.loop
            local cwd = uv.cwd()
            for _, p in ipairs({
              cwd .. "/.venv/bin/python", -- Unix
              cwd .. "/.venv/Scripts/python.exe", -- Windows
            }) do
              if vim.fn.executable(p) == 1 then
                config.settings = config.settings or {}
                config.settings.python = config.settings.python or {}
                config.settings.python.pythonPath = p
                break
              end
            end
          end

          require("lspconfig").pyright.setup(opts)
          return true -- tell LazyVim we handled setup
        end,
      },
    },
  },
}
