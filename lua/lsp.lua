local blink_capabilities = require('blink.cmp').get_lsp_capabilities()

-- Define all of the LSP servers you want, with optional per-server config
local servers = {
	clangd = {},
	gopls = {},
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
	ts_ls = {
		cmd = { "typescript-language-server", "--stdio" },
		filetypes = {
			"typescript",
			"typescriptreact",
			"javascript",
			"javascriptreact",
		},
		root_markers = {
			"package.json",
			"tsconfig.json",
			"jsconfig.json",
			".git",
		},
	},
	zls = {
		-- cmd = { vim.fn.expand('~/.zvm/master/zls') },
		cmd = { vim.fn.expand('~/.zvm/0.16.0/zls') },
		-- cmd = { vim.fn.expand('~/.zvm/0.15.2/zls') },
		settings = { zls = {}, },
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
