local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.2",
		dependencies = { { "nvim-lua/plenary.nvim" } },
	},

	{
		"dapc11/catppuccin",
		as = "catppuccin",
		config = function()
			vim.cmd("colorscheme catppuccin")
		end,
	},

	{
		"rose-pine/neovim",
		as = "rose-pine",
		config = function()
			vim.cmd("colorscheme rose-pine")
		end,
	},

	{
		"savq/melange-nvim",
		as = "melange",
		config = function()
			vim.cmd("colorscheme melange")
		end,
	},

	{
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup({
				icons = false,
			})
		end,
	},

  "ThePrimeagen/vim-be-good",
	"tpope/vim-obsession",
	"nvim-treesitter/nvim-treesitter",
	"nvim-treesitter/playground",
	"theprimeagen/harpoon",
	"theprimeagen/refactoring.nvim",
	"mbbill/undotree",
	"tpope/vim-fugitive",

	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		dependencies = {

			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },

			-- Snippets
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },
		},
	},
	"folke/zen-mode.nvim",
	"github/copilot.vim",
	"eandrju/cellular-automaton.nvim",
	"laytan/cloak.nvim",
	"mhartington/formatter.nvim",
}

require("lazy").setup(plugins, opts)
