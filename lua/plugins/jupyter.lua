return {
  -- Jupyter kernel + inline output
  {
    "benlubas/molten-nvim",
    version = "*",
    build = ":UpdateRemotePlugins", -- remote plugin, this is important
    dependencies = {
      "nvim-lua/plenary.nvim",
      "3rd/image.nvim", -- for inline images
    },
    init = function()
      -- make kernels start in the buffer's base directory
      vim.g.molten_use_base_dir = true

      -- where to show output; tweak to taste
      vim.g.molten_output_virt_lines = true
      vim.g.molten_auto_open_output = false
      vim.g.molten_virt_text_output = true
    end,
    keys = {
      { "<leader>mi", ":MoltenInit<CR>", desc = "Molten: init kernel" },

      -- Evaluate via operator/motion OR via visual mode
      { "<leader>me", ":MoltenEvaluateOperator<CR>", desc = "Molten: run operator", mode = "n" },
      { "<leader>me", ":<C-u>MoltenEvaluateVisual<CR>gv", desc = "Molten: run selection", mode = "v" },

      -- Run current line
      { "<leader>ml", ":MoltenEvaluateLine<CR>", desc = "Molten: run line" },

      -- Re-run currently active Molten cell
      { "<leader>mr", ":MoltenReevaluateCell<CR>", desc = "Molten: re-run cell" },

      -- *** Run current notebook cell (markdown fence or # %% block) ***
      {
        "<leader>mc",
        function()
          local ft = vim.bo.filetype

          -- Markdown / Quarto: use Treesitter fenced code block
          if ft == "markdown" or ft == "quarto" then
            local ok, ts = pcall(require, "vim.treesitter")
            if not ok then
              vim.notify("Treesitter not available for markdown", vim.log.levels.WARN)
              return
            end

            local node = ts.get_node()
            if not node then
              vim.notify("No Treesitter node under cursor", vim.log.levels.WARN)
              return
            end

            -- Walk up to the fenced code block node
            while node and node:type() ~= "fenced_code_block" and node:type() ~= "code_fence_content" do
              node = node:parent()
            end
            if not node then
              vim.notify("Not in a fenced code block", vim.log.levels.WARN)
              return
            end

            local start_row, _, end_row, _ = node:range()
            -- Skip opening fence line; end_row is already last code line for this node
            vim.fn.MoltenEvaluateRange(start_row + 1, end_row)
          else
            -- Python-style percent cells: # %% markers
            local cur = vim.fn.line(".")

            -- Search backwards for a cell start
            local start_line = vim.fn.search("^# %%", "bnW")
            if start_line == 0 then
              start_line = 1
            end

            -- Search forwards for the next cell start
            local next_cell = vim.fn.search("^# %%", "nW")
            local end_line
            if next_cell == 0 then
              end_line = vim.fn.line("$")
            else
              end_line = next_cell - 1
            end

            -- If the start line itself is a marker, skip it when sending code
            local start_text = vim.fn.getline(start_line)
            if start_text:match("^# %%%%") then
              start_line = start_line + 1
            end

            if start_line > end_line then
              vim.notify("No code in current cell", vim.log.levels.WARN)
              return
            end

            vim.fn.MoltenEvaluateRange(start_line, end_line)
          end
        end,
        desc = "Molten: run current cell",
      },

      -- === Cell navigation ===

      -- Next cell (markdown fences or # %%)
      {
        "<leader>j",
        function()
          local ft = vim.bo.filetype

          if ft == "markdown" or ft == "quarto" then
            -- search forward for next fenced block opening
            local next_fence = vim.fn.search("^```python", "nW")
            if next_fence == 0 then
              vim.notify("No next cell", vim.log.levels.INFO)
              return
            end
            -- jump to first line *inside* the fence
            vim.api.nvim_win_set_cursor(0, { next_fence + 1, 0 })
          elseif ft == "python" then
            -- search forward for next # %% marker
            local next_cell = vim.fn.search("^# %%", "nW")
            if next_cell == 0 then
              vim.notify("No next cell", vim.log.levels.INFO)
              return
            end
            vim.api.nvim_win_set_cursor(0, { next_cell + 1, 0 })
          else
            vim.notify("Cell navigation not defined for filetype " .. ft, vim.log.levels.INFO)
          end
        end,
        desc = "Molten: next cell",
      },

      -- Previous cell (markdown fences or # %%)
      {
        "<leader>k",
        function()
          local ft = vim.bo.filetype

          if ft == "markdown" or ft == "quarto" then
            -- 1. Find the fence that starts the *current* cell (no movement)
            local this_fence = vim.fn.search("^```python", "bnW")
            if this_fence == 0 then
              vim.notify("No previous cell", vim.log.levels.INFO)
              return
            end

            -- 2. If that fence is on the first line, there is no previous cell
            if this_fence <= 1 then
              vim.notify("No previous cell", vim.log.levels.INFO)
              return
            end

            -- 3. Move cursor to the line *above* the current fence
            vim.api.nvim_win_set_cursor(0, { this_fence - 1, 0 })

            -- 4. Now search backwards again, this time *moving* to the previous fence
            local prev_fence = vim.fn.search("^```python", "bW")
            if prev_fence == 0 then
              vim.notify("No previous cell", vim.log.levels.INFO)
              return
            end

            -- 5. Jump to first line inside the previous fence
            vim.api.nvim_win_set_cursor(0, { prev_fence + 1, 0 })
          elseif ft == "python" then
            -- Python-style percent cells: # %% markers

            -- 1. Find the marker that starts the *current* cell (no movement)
            local this_cell = vim.fn.search("^# %%", "bnW")
            if this_cell == 0 then
              vim.notify("No previous cell", vim.log.levels.INFO)
              return
            end

            if this_cell <= 1 then
              vim.notify("No previous cell", vim.log.levels.INFO)
              return
            end

            -- 2. Move cursor to the line above the current cell start
            vim.api.nvim_win_set_cursor(0, { this_cell - 1, 0 })

            -- 3. Search backwards again to find the previous cell start
            local prev_cell = vim.fn.search("^# %%", "bW")
            if prev_cell == 0 then
              vim.notify("No previous cell", vim.log.levels.INFO)
              return
            end

            -- 4. Jump to first line inside that cell
            vim.api.nvim_win_set_cursor(0, { prev_cell + 1, 0 })
          else
            vim.notify("Cell navigation not defined for filetype " .. ft, vim.log.levels.INFO)
          end
        end,
        desc = "Molten: previous cell",
      },

      -- Show output
      { "<leader>mO", ":MoltenShowOutput<CR>", desc = "Molten: show output" },

      -- Enter output
      {
        "<leader>mo",
        function()
          vim.cmd("MoltenShowOutput") -- ensure output window exists
          vim.cmd("noautocmd MoltenEnterOutput") -- enter it immediately
        end,
        desc = "Molten: enter output window",
      },

      -- Delete current cell
      { "<leader>md", ":MoltenDelete<CR>", desc = "Molten: delete cell" },

      -- De-init kernel
      { "<leader>mD", ":MoltenDeinit<CR>", desc = "Molten: deinit kernel" },
    },
  },

  -- Edit .ipynb via Jupytext
  {
    "goerz/jupytext.nvim",
    opts = {
      -- minimal example; defaults are sane
      -- you can configure formats if you like:
      format = "md",
      -- format = "py:percent",
    },
    init = function()
      -- Automatically cd into the directory of the notebook
      -- for real .ipynb buffers and for Jupytext-converted buffers.
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
          -- Real .ipynb file
          if vim.fn.expand("%:e") == "ipynb" then
            local dir = vim.fn.expand("%:p:h")
            if dir ~= "" then
              vim.cmd("cd " .. dir)
            end
            return
          end

          -- Buffer created by jupytext.nvim from an .ipynb source
          local src = vim.b.jupytext_source_file
          if src and src ~= "" then
            local dir = vim.fn.fnamemodify(src, ":h")
            if dir ~= "" then
              vim.cmd("cd " .. dir)
            end
          end
        end,
      })
    end,
  },
}
