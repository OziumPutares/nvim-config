return {
  'chomosuke/typst-preview.nvim',
  lazy = false, -- or ft = 'typst'
  version = '1.*',

  opts = {}, -- lazy.nvim will implicitly calls `setup {}`
  config = function()
    require 'typst-preview'.setup {
      cmd = "firefox --new-window %s"
    }
    vim.keymap.set("n", "<LocalLeader>ll", "<cmd>TypstPreviewToggle<cr>")
  end
}
