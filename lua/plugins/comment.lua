-- ~/.config/nvim/lua/plugins/comment.lua
return {
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" }, -- optional but recommended
    opts = function()
      -- try to get the ts-context helper, but don't fail if it's absent
      local has_ts, ts_comment = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
      return {
        -- general behaviour
        padding = true, -- add a space b/w comment and the line
        sticky = true, -- whether the cursor remains after commenting
        ignore = nil, -- e.g. '^$' to ignore empty lines

        -- mappings (toggler = toggle comment with special mapping)
        toggler = {
          line = "gcc", -- toggle line comment
          block = "gbc", -- toggle block comment
        },
        -- operator-pending mappings (use with motions)
        opleader = {
          line = "gc",
          block = "gb",
        },
        -- extra mappings
        extra = {
          above = "gcO",
          below = "gco",
          eol = "gcA",
        },
        -- mapping subsets (set false to disable)
        mappings = {
          basic = true, -- gcc, gc{motion}, gb{motion}
          extra = true, -- gco, gcO, gcA
          extended = false,
        },

        -- integrate with treesitter context (for JSX/embedded languages)
        pre_hook = has_ts and ts_comment.create_pre_hook() or nil,
      }
    end,
  },
}
