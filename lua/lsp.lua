local blink_capabilities = require('blink.cmp').get_lsp_capabilities()

-- Define all of the LSP servers you want, with optional per-server config
local servers = {
	clangd = {},
	lua_ls = {
		settings = {
			Lua = {
				workspace = { library = vim.api.nvim_get_runtime_file("", true) },
				completion = {
					callSnippet = "Enable",
					keywordSnippet = "Enable",
				},
				diagnostics = { globals = { "vim" } },
			},
		},
	},
	pyright = {},
	ruff = {},
	rust_analyzer = {
		settings = {
			['rust-analyzer'] = {
				completion = {
					callable = {
						snippets = "add_parentheses"
					},
					snippets = {
					},
				},
			}
		},
	},
	zls = {
		settings = {
			zls = {
			},
		},
	},
}



for name, cfg in pairs(servers) do
	cfg.capabilities = vim.tbl_deep_extend(
		"force",
		{},
		blink_capabilities,
		cfg.capabilities or {}
	)

	vim.lsp.config(name, cfg)
end

vim.lsp.enable(vim.tbl_keys(servers))
