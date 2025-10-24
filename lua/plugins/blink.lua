vim.pack.add({
	{ src = 'https://github.com/saghen/blink.cmp', version = "1.*" },
})

require("blink.cmp").setup(
	{
		signature = { enabled = true },
		keymap = {
			preset = 'none',
			['<C-i>'] = { 'show', 'show_documentation', 'hide_documentation', 'fallback' },
			['<C-e>'] = { 'hide', 'fallback' },
			['<C-y>'] = { 'select_and_accept', 'fallback' },

			['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
			['<C-n>'] = { 'select_next', 'fallback_to_mappings' },

			['Up'] = { 'scroll_documentation_up', 'fallback' },
			['<Down>'] = { 'scroll_documentation_down', 'fallback' },

			['<Tab>'] = { 'snippet_forward', 'fallback' },
			['<S-Tab>'] = { 'snippet_backward', 'fallback' },

			['<C-a>'] = { 'show_signature', 'hide_signature', 'fallback' },
		},
		appearance = {
			nerd_font_variant = 'mono',
			kind_icons = {
				Snippet = '' -- cause why not
			},
		},
		sources = {
			default = { 'lsp', 'path', 'buffer', 'snippets' },
			providers = {
				snippets = {
					async = true,
				},
				buffer = {
					async = true,
				},
			},
		},
		snippets = {
			preset = 'luasnip',
		},
		completion = {
			-- ghost_text = { enabled = true },
			documentation = { auto_show = true },
			menu = {
				auto_show = true,
				draw = {
					treesitter = { "lsp" },
					columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'kind' } },
				},
			},
		},
		fuzzy = { implementation = "prefer_rust_with_warning" },
	}
)
