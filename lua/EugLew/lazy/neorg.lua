return {
	{
		"vhyrro/luarocks.nvim",
		priority = 1000,
		config = true,
	},
	{
		"nvim-neorg/neorg",
		dependencies = { "luarocks.nvim" },
		-- tag = "*",
		lazy = false, -- enable lazy load
		ft = "norg", -- lazy load on file type
		cmd = "Neorg", -- lazy load on command
		config = function()
			vim.cmd("set conceallevel=3")
			vim.keymap.set("n", "<leader>nw", function()
				vim.cmd("Neorg index")
			end)
			vim.keymap.set("n", "<Leader>nr", function()
				vim.cmd("Neorg return")
			end)
			require("neorg").setup({
				load = {
					["core.defaults"] = {}, -- Loads default behaviour
					["core.concealer"] = {
						config = {
							icons = {
								todo = {
									uncertain = {
										icon = "?",
									},
								},
							},
							icons_preset = {
								"diamond",
							},
						},
					}, -- Adds pretty icons to your documents
					["core.dirman"] = { -- Manages Neorg workspaces
						config = {
							workspaces = {
								notes = "~/notes",
							},
							default_workspace = "notes",
						},
					},
					["core.keybinds"] = {
						config = {
							hook = function(keybinds)
								keybinds.map("norg", "n", "<LocalLeader>nt", "<cmd>Neorg toc<CR>")
							end,
						},
					},
				},
			})
		end,
	},
}
