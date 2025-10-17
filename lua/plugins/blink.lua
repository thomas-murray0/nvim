vim.pack.add({
	{ src = 'https://github.com/saghen/blink.cmp', version = "1.*" },
})
require("blink.cmp").setup(
	{
		signature = { enabled = true },
		keymap = {
			preset = 'default',
		},
		appearance = {
			nerd_font_variant = 'mono'
		},
		sources = {
			default = { 'lsp', 'path', 'buffer', 'snippets' },
		},
		snippets = { preset = 'luasnip' },
		completion = {
			documentation = { auto_show = true },
			menu = {
				auto_show = true,
				draw = { treesitter = { "lsp" } }
			},
		},
		fuzzy = { implementation = "prefer_rust_with_warning" },
	}
)
