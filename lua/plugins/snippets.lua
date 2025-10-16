vim.pack.add({
	{ src = "https://github.com/L3MON4D3/LuaSnip", name = "luasnip"},
})

require("luasnip").setup(
	{
		enable_autosnippets = true,
	}
)
require("luasnip.loaders.from_lua").load({ paths = "~/dotfiles/.config/nvim/lua/snippets/" })
