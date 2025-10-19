vim.pack.add({
	{ src = "https://github.com/L3MON4D3/LuaSnip", name = "luasnip"},
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
})

local luasnip = require("luasnip")
luasnip.setup()
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_lua").load({ paths = "~/dotfiles/.config/nvim/lua/snippets/" })
