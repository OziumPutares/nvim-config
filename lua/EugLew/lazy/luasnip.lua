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
      -- Main snippet
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
      -- Include guard snippet
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
      -- struct snippet

      s("str", fmt([[
{}{} {} {{
}};]], {
        c(1, { t("struct "), t("class ") }),
        c(2, {
          t(""), fmt([[[[nodiscard("{}")]] .. "]] ", { i(1) }), fmt("[[{}]] ", { i(1) })
        }),
        i(3)
      })),
      --
      -- template snippet
      --
      s("te", fmt([[
template<{}{} {}>]], {
        c(1, { t("typename"), t("auto"), fmt("{}", { i(1) }), t("typename..."), t("auto...") }),
        c(2, { t(""), t("...") }),
        i(3)
      }
      )),
      --
      -- [[nodiscard]] snippet
      --
      s("no", t("[[nodiscard]]")),
      --
      -- Function snippet
      --
      s("fu",
        fmt([[{}{}auto {}({}){} -> {} {{
}}]],
          {
            c(1, { t("[[nodiscard]] "), t("") }),
            c(2, { t("constexpr "), t("") }),
            i(3),
            i(4),
            c(5, { t(" noexcept", t("")) }),
            i(6)
          }
        ))
    })
    ls.add_snippets("typst", {
      --- theorem
      s("thm", fmt([[#theorem[{}][{}] {} ]], { i(1), i(2), c(3, { fmt("<thm:{}>", { i(1) }), t("") }) })),
      ---definition
      s("def",
        fmt([[#definition{}[{}] {} ]], { c(1, { t "-box", t "", }), i(2), c(3, { fmt("<def:{}>", { i(1) }), t("") }) })),
      ---lemma
      s("lem", fmt([[#lemma[{}] {} ]], { i(1), c(2, { fmt("<lem:{}>", { i(1) }), t("") }) })),
      ---corollary
      s("cor", fmt([[#corollary[{}] {} ]], { i(1), c(2, { fmt("<cor:{}>", { i(1) }), t("") }) })),
      ---proposition
      s("prop", fmt([[#proposition[{}] {} ]], { i(1), c(2, { fmt("<prop:{}>", { i(1) }), t("") }) })),
      ---conjecture
      s("con", fmt([[#conjecture[{}][{}] {} ]], { i(1), i(2), c(3, { fmt("<con:{}>", { i(1) }), t("") }) })),
      ---axiom
      s("axiom", fmt([[#axiom[{}][{}] {} ]], { i(1), i(2), c(3, { fmt("<axiom:{}>", { i(1) }), t("") }) })),
      ---postulate
      s("post", fmt([[#postulate[{}][{}] {} ]], { i(1), i(2), c(3, { fmt("<post:{}>", { i(1) }), t("") }) })),
      ---property
      s("property", fmt([[#property[{}] {} ]], { i(1), c(2, { fmt("<prty:{}>", { i(1) }), t("") }) })),
      ---assumption
      s("ass", fmt([[#assumption[{}] {} ]], { i(1), c(2, { fmt("<ass:{}>", { i(1) }), t("") }) })),
      ---example
      s("exa", fmt([[#example[{}] {} ]], { i(1), c(2, { fmt("<exa:{}>", { i(1) }), t("") }) })),
      ---proof
      s("prf", fmt([[#proof[{}][{}] {} ]], { i(1), i(2), c(3, { fmt("<prf:{}>", { i(1) }), t("") }) })),
      ---solution
      s("sol",
        fmt([[#solution{} [{}] {} ]],
          { c(1, { t("(qed: auto)"), t("") }), i(2), c(3, { fmt("<sol:{}>", { i(1) }), t("") }) })),
      ---problem
      s("prob", fmt([[#problem[{}] {} ]], { i(1), c(2, { fmt("<prob:{}>", { i(1) }), t("") }) })),
      ---exercise
      s("ex", fmt([[#exercise[{}] {} ]], { i(1), c(2, { fmt("<ex:{}>", { i(1) }), t("") }) })),
      ---conclusion
      s("conc", fmt([[#conclusion[{}] {} ]], { i(1), c(2, { fmt("<conc:{}>", { i(1) }), t("") }) })),
      s("qed", t("#qedhere")),
      s("rethm", fmt("#theorion-restate(@thm:{})", { i(1) })),
      s("tbox", fmt([[#theorem-box[{}] [{}] {} ]], { i(1), i(2), c(3, { fmt("<thm:{}>", { i(1) }), t("") }) })),

      --- TODO Add the rest
      ---note-block

      ---remark-block
      s("remark", fmt([[#remark-block[{}] ]], { i(1) })),
      ---important-block
      s("important", fmt([[#important-block[{}] ]], { i(1) })),
      ---tip-block
      s("tip", fmt([[#tip-block[{}] ]], { i(1) })),
      ---warning-block
      s("warn", fmt([[#warning-block[{}] ]], { i(1) })),
      ---caution-block
      s("caution", fmt([[#caution-block[{}] ]], { i(1) })),
      ---quote-block
      s("quote", fmt([[#quote-block[{}] ]], { i(1) })),
      ---emph-block
      s("emph", fmt([[#emph-block[{}] ]], { i(1) })),
      ---notation-box
      s("not", fmt([[#notation-box[{}]{} ]], { i(1), i(2) })),
      s("m", fmt([[${}$ {}]], { i(1), i(2) })),
    })
  end,
}
