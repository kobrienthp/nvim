return {
  "stevearc/conform.nvim",
  -- ensure this loads early enough to win over other specs (optional)
  priority = 1000,
  opts = {
    default_format_opts = {
      timeout_ms = 3000,
      async = false,
      quiet = false,
    },
    formatters = {
      ensure_newline = {
        stdin = true,
        command = "python",
        args = { "-c", [[import sys; d=sys.stdin.read(); sys.stdout.write(d.rstrip("\n")+"\n")]] },
      },
      latexindent_custom = {
        stdin = true,
        command = "latexindent",
        args = { "-y=defaultIndent:'  '" },
      },
    },
    formatters_by_ft = {
      tex = { "latexindent_custom" },
      -- sort imports FIRST, then format, then enforce one blank line
      python = { "ruff_organize_imports", "ruff_format", "ensure_newline" },
    },
    -- critical: do not fall back to LSP formatting
    --format_on_save = { lsp_fallback = false, timeout_ms = 2000 },
    notify_on_error = true,
  },
}
