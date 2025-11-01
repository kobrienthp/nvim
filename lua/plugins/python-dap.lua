return {
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "jay-babu/mason-nvim-dap.nvim",
      -- ADD THIS:
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require("mason-nvim-dap").setup({
        ensure_installed = { "python" },
        automatic_installation = true,
      })

      local function detect_py()
        local venv = vim.env.VIRTUAL_ENV
        if venv and #venv > 0 then
          return venv .. "/bin/python"
        end
        local cwd = vim.fn.getcwd()
        if vim.fn.filereadable(cwd .. "/.venv/bin/python") == 1 then
          return cwd .. "/.venv/bin/python"
        end
        return "python3"
      end

      local dap_ok, dap_python = pcall(require, "dap-python")
      if dap_ok then
        dap_python.setup(detect_py())
        dap_python.test_runner = "pytest"
      end

      -- If you already imported `lazyvim.plugins.extras.dap.core`,
      -- DAP UI is usually configured for you. If you *also* want the custom
      -- layout below, keep this block. Otherwise you may delete it.
      local dap = require("dap")
      local dapui = require("dapui")

      -- Safe, idempotent setup guard
      if not vim.g._dapui_configured then
        require("dapui").setup({
          controls = { enabled = true, element = "repl" },
          layouts = {
            {
              elements = { "scopes", "breakpoints", "stacks" },
              size = 40,
              position = "left",
            },
            {
              elements = { "repl", "console" },
              size = 0.25,
              position = "bottom",
            },
          },
        })
        vim.g._dapui_configured = true
      end

      require("nvim-dap-virtual-text").setup({ enabled = true, commented = true })

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
      end
      map("n", "<F5>", function()
        dap.continue()
      end, "DAP: Continue / Start")
      map("n", "<F9>", function()
        dap.toggle_breakpoint()
      end, "DAP: Toggle Breakpoint")
      map("n", "<F10>", function()
        dap.step_over()
      end, "DAP: Step Over")
      map("n", "<F11>", function()
        dap.step_into()
      end, "DAP: Step Into")
      map("n", "<S-F11>", function()
        dap.step_out()
      end, "DAP: Step Out")
      map("n", "<F6>", function()
        dap.terminate()
      end, "DAP: Terminate")
      map("n", "<leader>du", function()
        dapui.toggle()
      end, "DAP UI: Toggle")
      map("n", "<leader>dl", function()
        dap.run_last()
      end, "DAP: Run Last")
      map("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, "DAP: Conditional Breakpoint")

      map("n", "<leader>dtn", function()
        dap_python.test_method()
      end, "DAP: Test (nearest)")
      map("n", "<leader>dtf", function()
        dap_python.test_class()
      end, "DAP: Test (class)")
      map("v", "<leader>dtS", function()
        dap_python.debug_selection()
      end, "DAP: Debug selection")
    end,
  },
}
