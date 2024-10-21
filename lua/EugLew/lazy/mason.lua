return {
  "williamboman/mason-lspconfig.nvim",
  "jay-babu/mason-nvim-dap.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "mfussenegger/nvim-dap",
  },
  config = function()
    require("mason").setup({
      "codelldb",
      "cmakelang",
      "cpplint",
      "stylua",
      "clang-format",
    })
    local mason_nvim_dap = require("mason-nvim-dap")
    mason_nvim_dap.setup({
      ensure_installed = {
        "cpptools",
      },
      handlers = {},
    })
  end,
}
