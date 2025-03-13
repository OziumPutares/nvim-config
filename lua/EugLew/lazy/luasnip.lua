local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local LoadCSSnippets = function()
	ls.add_snippets("cs", {
		s(
			"main",
			fmt(
				[[using System;
class {}
{{
    static void Main(string[] args)
    {{
      {}
    }}
}}
]],
				{
					i(1, "Program"),
					i(2, 'Console.WriteLine("Hello, World!");'),
				}
			)
		),
		s("cw", fmt("System.Console.WriteLine({});\n", { i(1, '"hello world"') })),
	})
end
local LoadCPPSnippets = function()
	ls.add_snippets("cpp", {
		s(
			"main",
			fmt(
				"int main({}){{\n {}\n }}",
				{ c(1, { t(""), t("int argc, char *argv[]") }), i(2, 'std::println("Hello, World!");') }
			)
		),

		s(
			"cFn",
			fmt("{} auto {}({}) {} {{\n {}\n}}", {
				c(1, { t("[[nodiscard]]"), fmt("[[{}]]", { i(1) }), t("") }),
				i(2, "FuncName"),
				i(3, "funcParams"),
				ls.snippet_node(4, fmt("{} -> {}", { i(1, "specifiers"), i(2, "return type") })),
				i(5, "functionBody"),
			})
		),
	})
end
return {
	"L3MON4D3/LuaSnip",
	-- follow latest release.
	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- install jsregexp (optional!).
	build = "make install_jsregexp",
	config = function()
		ls.config.set_config({
			history = true,
			updateevents = "TextChanged,TextChangedI",

			enable_autosnippets = true,
		})
		vim.keymap.set({ "i", "s" }, "<C-k>", function()
			if ls.expand_or_jumpable() then
				ls.expand_or_jump()
			end
		end, { silent = true })
		vim.keymap.set({ "i", "s" }, "<C-j>", function()
			if ls.jumpable(-1) then
				ls.jump(-1)
			end
		end, { silent = true })
		vim.keymap.set({ "i" }, "<C-l>", function()
			if ls.choice_active() then
				ls.change_choice(1)
			end
		end, { silent = true })
		vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/lua/EugLew/lazy/luasnip.lua<CR>")

		--ls.add_snippets("lua", s(ls.parser.parse_snippet("lf", "local $1 = function($2)\n $0\nend")))
		ls.add_snippets("lua", { s("ex", {
			t("--this is a comment"),
		}) })
		ls.add_snippets("lua", { s("req", fmt("local {} = require('{}')", { i(1, "default"), rep(1) })) })
		ls.add_snippets("lua", { s("lf", fmt("local {} = function()\n{}\nend", { i(1, "default"), i(2) })) })
		LoadCSSnippets()
		LoadCPPSnippets()
	end,
}
