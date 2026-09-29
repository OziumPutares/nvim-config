return {
  'chomosuke/typst-preview.nvim',
  lazy = false, -- or ft = 'typst'
  version = '1.*',

  opts =
  {
    open_cmd = "firefox %s -P typst-preview --class typst-preview"
  }, -- lazy.nvim will implicitly calls `setup {}`
  keys = {
    {
      '<LocalLeader>ll',
      '<cmd>TypstPreviewToggle<cr>',
      desc = 'Toggle Typst preview',
      ft = 'typst',
    },
  },
}
