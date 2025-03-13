return {

	"nvim-telescope/telescope.nvim",
	tag = "0.1.5",
	dependencies = { { "nvim-lua/plenary.nvim" } },

	config = function()
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
		vim.keymap.set("n", "<leader>fd", builtin.git_files, {})
		vim.keymap.set("n", "<leader>fn", function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end)
		vim.keymap.set("n", "<leader>fl", builtin.live_grep, {})
		vim.keymap.set("n", "<leader>fc", builtin.current_buffer_fuzzy_find, {})
		vim.keymap.set("n", "<leader>gb", builtin.git_branches, {})
		vim.keymap.set("n", "<leader>fr", builtin.lsp_references, {})
		vim.keymap.set("n", "<leader>fsc", builtin.lsp_document_symbols, {})
		vim.keymap.set("n", "<leader>fsw", builtin.lsp_document_symbols, {})
	end,
}
