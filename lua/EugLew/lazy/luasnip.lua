return {
  "L3MON4D3/LuaSnip",
  dependencies = {
    {
      "saadparwaiz1/cmp_luasnip",
      dependencies = {
        "hrsh7th/nvim-cmp",
      },
    }
  },

  version = "v2.*",

  config = function()
    local cmp = require 'cmp'

    cmp.setup({
      snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
          require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' }, -- For luasnip users.
        { name = "neorg" },
        { name = "path" },
      }, {
        { name = 'buffer' },
      })
    })
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    local c = ls.choice_node
    local fmt = require("luasnip.extras.fmt").fmt
    local rep = require("luasnip.extras").rep

    ls.config.set_config({
      history = true,
      updateevents = "TextChanged,TextChangedI",
      enable_autosnippets = true,
    })

    -- Keymaps
    vim.keymap.set({ "i", "s" }, "<C-k>", function()
      ls.expand_or_jump()
    end)

    vim.keymap.set({ "i", "s" }, "<C-j>", function()
      ls.jump(-1)
    end)

    vim.keymap.set("i", "<C-l>", function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end)

    -- Lua snippets
    ls.add_snippets("lua", {
      s("ex", {
        t("-- this is a comment"),
      }),

      s("req", fmt("local {} = require('{}')", {
        i(1, "default"),
        rep(1),
      })),

      s("lf", fmt("local {} = function()\n{}\nend", {
        i(1, "name"),
        i(2),
      })),
    })

    -- C# snippets
    ls.add_snippets("cs", {
      s("main", fmt([[
using System;

class {}
{{
    static void Main(string[] args)
    {{
        {}
    }}
}}
      ]], {
        i(1, "Program"),
        i(2, 'Console.WriteLine("Hello, World!");'),
      })),
    })

    -- C++ snippets
    local f = ls.function_node
    local fmt = require("luasnip.extras.fmt").fmt
    local function include_guard()
      local filename = vim.fn.expand("%:t")
      return filename
          :upper()
          :gsub("[^A-Z0-9]", "_")
    end
    ls.add_snippets("cpp", {
      s("main", fmt([[
int main({}) {{
    {}
}}
      ]], {
        c(1, {
          t(""),
          t("int argc, char *argv[]"),
        }),
        i(2, 'std::cout << "Hello World";'),
      })),
      s("guard", fmt([[
#ifndef {}
#define {}

{}

#endif // {}
]], {
        f(include_guard),
        f(include_guard),
        i(1),
        f(include_guard),
      })),
    })
  end,
}
