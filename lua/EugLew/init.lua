require("EugLew.remap")
require("EugLew.plugins")
require("EugLew.set")
--print("hello from me")

local augroup = vim.api.nvim_create_augroup
local TheEugLewGroup = augroup("EugLew", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})
local save = augroup("format", {})

function R(name)
	require("plenary.reload").reload_module(name)
end

autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

autocmd({ "BufWritePre" }, {
	group = TheEugLewGroup,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

augroup("__formatter__", { clear = true })
autocmd("BufWritePost", {
	group = "__formatter__",
	command = ":FormatWrite",
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
