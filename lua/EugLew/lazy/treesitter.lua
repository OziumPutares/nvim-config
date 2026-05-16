return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',

  event = { "BufReadPost", "BufNewFile" },

  config = function()
    local ok, ts = pcall(require, "nvim-treesitter.configs")
    if not ok then
      return
    end

    ts.setup({
      ensure_installed = {
        "c",
        "cpp",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "norg",
      },

      sync_install = true,
      auto_install = true,


      indent = {
        enable = true,
      },
    })

    -- Disable treesitter for LaTeX (can be buggy)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "tex",
      callback = function()
        vim.cmd("TSBufDisable highlight")
      end,
    })
  end,
}
