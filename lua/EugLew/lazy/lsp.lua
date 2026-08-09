return {
  "mason-org/mason.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "mason-org/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "j-hui/fidget.nvim",
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
  },

  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local cmp_lsp = require("cmp_nvim_lsp")

    -- Capabilities for completion
    local capabilities = cmp_lsp.default_capabilities()

    -- UI
    require("fidget").setup({})
    mason.setup()

    -- Ensure servers are installed
    mason_lspconfig.setup({
      ensure_installed = {
        "lua_ls",
        "bashls",
        "clangd",
        "pyright",
        "csharp_ls",
        "eslint",
        "texlab",
        "hls",
        "glsl_analyzer",
        "wgsl-analyzer",
        "qmlls",
        "astro",
        "tinymist"
      },
    })

    -- Helper: new Neovim 0.11 LSP API
    local function setup(server, config)
      config = config or {}
      config.capabilities = capabilities

      vim.lsp.config(server, config)
      vim.lsp.enable(server)
    end

    -- Default servers
    setup("bashls")
    setup("pyright")
    setup("eslint")
    setup("texlab")
    setup("cmake")
    setup("hls")
    setup("glslls")
    setup("qmlls")
    setup("tinymist")

    setup("astro",
      { init_options = { typescript = { tsdk = vim.fn.stdpath("data") .. "/mason/packages/typescript-language-server/node_modules/typescript/lib" } } })
    setup("wgsl-analyzer", {
      filetypes = { "wgsl", "wesl" },
      capabilities = capabilities,
    })

    -- Lua LS
    setup("lua_ls", {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    })

    -- clangd
    setup("clangd", {
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--suggest-missing-includes",
      },
      filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    })

    -- C#
    setup("csharp_ls", {
      root_dir = function(bufnr, on_dir)
        local path = vim.api.nvim_buf_get_name(bufnr)
        local util = vim.fs

        on_dir(
          util.find(".git", { path = path, upward = true })[1]
          or util.find("*.sln", { path = path, upward = true })[1]
          or util.find("*.csproj", { path = path, upward = true })[1]
        )
      end,
    })

    -- Diagnostics UI
    vim.diagnostic.config({
      float = {
        border = "rounded",
        source = "always",
      },
    })
  end,
}
