return {
  {
    "afewyards/codereview.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = {
      "CodeReview",
      "CodeReviewStart",
      "CodeReviewSubmit",
      "CodeReviewApprove",
      "CodeReviewOpen",
      "CodeReviewPipeline",
      "CodeReviewComments",
      "CodeReviewFiles",
      "CodeReviewToggleScroll",
      "CodeReviewCommits",
    },
    opts = {
      -- Let the plugin infer GitHub/GitLab and owner/repo from git remote.
      platform = nil,
      project = nil,
      base_url = nil,

      picker = "snacks",

      -- Useful while first setting this up.
      -- Later set this to false.
      debug = true,

      -- Open reviews in a separate tab.
      open_in_tab = true,

      diff = {
        context = 8,
        scroll_threshold = 50,
        comment_width = 80,
        separator_char = "╳",
        separator_lines = 3,
      },

      pipeline = {
        poll_interval = 10000,
        log_max_lines = 5000,
      },

      keymaps = {
        quit = "q",

        -- Optional: avoid possible conflict with LazyVim/git hunks if desired.
        -- next_file = "]F",
        -- prev_file = "[F",
      },
    },
  },
}
