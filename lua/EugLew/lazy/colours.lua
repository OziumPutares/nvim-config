function ColorMyPencils(color)
  --color = color or "melange"
  --color = color or "rose-pine"
  --color = color or "catppuccin"
  --color = color or "kanagawa-wave"
  color = color or "kanagawa-dragon"
  vim.cmd.colorscheme(color)

  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
  {
    --"rose-pine/neovim",
    --"dapc11/catppuccin",
    --"rose-pine/neovim",
    --"savq/melange-nvim",
    "rebelot/kanagawa.nvim",
    --name = "rose-pine",
    config = function()
      --			require("kanagawa").setup({
      --				compile = true,
      --				transparent = true,
      --				colors = {
      --					theme = {
      --						all = {
      --							ui = {
      --								bg_gutter = "none",
      --							},
      --						},
      --					},
      --				},
      --overrides = function(colors)
      --	local theme = colors.theme
      --	return {
      --		Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
      --		PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
      --		PmenuSbar = { bg = theme.ui.bg_m1 },
      --		PmenuThumb = { bg = theme.ui.bg_p2 },
      --	}
      --end,
      --			})
      --require("rose-pine").setup({
      --	disable_background = true,
      --})

      vim.opt.termguicolors = true
      vim.cmd("colorscheme kanagawa-dragon")

      ColorMyPencils()
    end,
  },
}
