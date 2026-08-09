return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      -- Conform will run multiple formatters sequentially
      python = { "isort", "black" },
      cpp = { "clang-format", lsp_format = "fallback" },
      cs = { "dotnet", lsp_format = "fallback" },
      -- You can customize some of the format options for the filetype (:help conform.format)
      rust = { "rustfmt", lsp_format = "fallback" },
      js = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      cmake = { "cmake_format" },
      astro = { "prettierd", "prettier", stop_after_first = true },
      -- Conform will run the first available formatter
    },
    format_on_save = {
      -- These options will be passed to conform.format()
      timeout_ms = 10000,
      lsp_format = "fallback",
    },
  },
}
