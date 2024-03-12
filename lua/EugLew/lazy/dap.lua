return {

	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"jay-babu/mason-nvim-dap.nvim",
			dependencies = {
				"williamboman/mason.nvim",
				"mfussenegger/nvim-dap",
			},
		},
		config = function()
			local mason_nvim_dap = require("mason-nvim-dap")
			mason_nvim_dap.setup({
				ensure_installed = {
					"codelldb",
				},
				handlers = {},
			})

			vim.keymap.set("n", "<leader>dc", function()
				require("dap").continue()
			end)
			vim.keymap.set("n", "<leader>do", function()
				require("dap").step_over()
			end)
			vim.keymap.set("n", "<leader>di", function()
				require("dap").step_into()
			end)
			vim.keymap.set("n", "<leader>du", function()
				require("dap").step_out()
			end)
			vim.keymap.set("n", "<Leader>db", function()
				require("dap").toggle_breakpoint()
			end)
			vim.keymap.set("n", "<Leader>dB", function()
				require("dap").set_breakpoint()
			end)
			vim.keymap.set("n", "<Leader>lp", function()
				require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end)
			vim.keymap.set("n", "<Leader>dr", function()
				require("dap").repl.open()
			end)
			vim.keymap.set("n", "<Leader>dl", function()
				require("dap").run_last()
			end)

			local dap, dapui = require("dap"), require("dapui")
			dapui.setup({})
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
		end,
	},
}
