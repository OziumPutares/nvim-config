return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
	},
	config = function()
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)
		require("fidget").setup({})
		require("mason").setup({
			"codelldb",
			"cmakelang",
			"cpplint",
			"stylua",
			"clang-format",
		})
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"bashls",
				"clangd",
				"cmake",
				"pyright",
				"csharp_ls",
				"eslint",
				"texlab",
				"haskell-language-server",
			},
			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,
				["lua_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim", "it", "describe", "before_each", "after_each" },
								},
							},
						},
					})
				end,
				["clangd"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.clangd.setup({
						capabilities = capabilities,
						settings = {
							["clangd"] = {
								cmd = {
									"clangd",
									"--background-index",
									"--std=c++23",
									"--clang-tidy",
									"--header-insertion=iwyu",
									"--suggest-missing-includes",
									"--experimental-modules-support",
								},
								filetypes = {
									{ "c", "cpp", "objc", "objcpp", "cuda", "proto" },
								},
							},
						},
					})
				end,
				["csharp_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.csharp_ls.setup({
						capabilities = capabilities,
						root_dir = function(startpath)
							return require("lspconfig").util.root_pattern("*.sln")(startpath)
								or require("lspconfig").util.root_pattern("*.csproj")(startpath)
								or require("lspconfig").util.root_pattern(".git")(startpath)
						end,
						handlers = {
							["textDocument/definition"] = require("lspconfig").util.location_handler,
						},
						on_attach = function(client, bufnr)
							-- Enable completion triggered by <c-x><c-o>
							vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
						end,
					})
				end,
				["texlab"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.texlab.setup({})
				end,
				["cmake"] = function()
					require("lspconfig").cmake.setup({})
				end,
				["hls"] = function()
					require("lspconfig").hls.setup({})
				end,
				["eslint"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.eslint.setup({})
				end,
			},
		})
		require("lspconfig").texlab.setup({})
		-- Rest of your configuration remains the same
		local cmp_select = { behavior = cmp.SelectBehavior.Select }
		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "path" },
			}),
		})
		vim.diagnostic.config({
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})
	end,
}
