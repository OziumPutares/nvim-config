vim.opt.termguicolors = true
--require("rose-pine").setup({
--	disable_background = true,
--})

function ColorMyPencils(color)
	--color = color or "melange"
	color = color or "rose-pine"
	--color = color or "catppuccin"
	--color = color or "kanagawa-wave"
	--color = color or "kanagawa-dragon"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
	{
		--"rose-pine/neovim",
		--"dapc11/catppuccin",
		"rose-pine/neovim",
		--"savq/melange-nvim",
		--"rebelot/kanagawa.nvim",
		name = "rose-pine",
		config = function()
			--require("rose-pine").setup({
			--	disable_background = true,
			--})

			vim.cmd("colorscheme rose-pine")

			ColorMyPencils()
		end,
	},
}
