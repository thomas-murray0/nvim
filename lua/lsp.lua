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
		cmd = { vim.fn.expand('~/.zvm/master/zls') },
		-- cmd = { vim.fn.expand('~/.zvm/0.15.2/zls') },
		-- cmd = { vim.fn.expand('~/.zvm/0.15.1/zls') },
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

-- SOME ZLS SHENANIGANS

-- local blink_capabilities = require('blink.cmp').get_lsp_capabilities()
--
-- -- Helper function to get Zig version and corresponding zls path
-- local function get_zls_config()
-- 	local handle = io.popen('zig version 2>&1')
-- 	if not handle then
-- 		return nil
-- 	end
--
-- 	local zig_version = handle:read('*a')
-- 	handle:close()
--
-- 	-- Extract version number (e.g., "0.15.2" from "0.15.2" or "0.16.0-dev.1976+...")
-- 	local major, minor, patch, dev = zig_version:match('(%d+)%.(%d+)%.(%d+)(%-dev)')
-- 	local is_dev = dev ~= nil
--
-- 	if not major or not minor then
-- 		major, minor = zig_version:match('(%d+)%.(%d+)')
-- 		if not major or not minor then
-- 			return nil
-- 		end
-- 	end
--
-- 	local version_prefix = major .. '.' .. minor
-- 	local zls_path
-- local blink_capabilities = require('blink.cmp').get_lsp_capabilities()
--
-- -- Helper function to get Zig version and corresponding zls path
-- local function get_zls_config()
-- 	local handle = io.popen('zig version 2>&1')
-- 	if not handle then
-- 		return nil
-- 	end
--
-- 	local zig_version = handle:read('*a')
-- 	handle:close()
--
-- 	-- Extract version number (e.g., "0.15.2" from "0.15.2" or "0.16.0-dev.1976+...")
-- 	local major, minor, patch, dev = zig_version:match('(%d+)%.(%d+)%.(%d+)%-dev')
-- 	local is_dev = dev ~= nil
--
-- 	if not major or not minor then
-- 		major, minor = zig_version:match('(%d+)%.(%d+)')
-- 		if not major or not minor then
-- 			return nil
-- 		end
-- 	end
--
-- 	local version_prefix = major .. '.' .. minor
-- 	local zls_path
--
-- 	-- If it's a dev version, try master first
-- 	if is_dev then
-- 		zls_path = vim.fn.expand('~/.zvm/master/zls')
-- 		if vim.fn.executable(zls_path) == 1 then
-- 			return { cmd = { zls_path } }
-- 		end
-- 	end
--
-- 	-- Try exact version first
-- 	zls_path = vim.fn.expand('~/.zvm/' .. zig_version:match('(%S+)') .. '/zls')
-- 	if vim.fn.executable(zls_path) == 0 then
-- 		-- Try with major.minor.0
-- 		zls_path = vim.fn.expand('~/.zvm/' .. version_prefix .. '.0/zls')
-- 		if vim.fn.executable(zls_path) == 0 then
-- 			-- Fall back to any version in that major.minor range
-- 			local zvm_dir = vim.fn.expand('~/.zvm/')
-- 			local versions = vim.fn.readdir(zvm_dir)
-- 			for _, v in ipairs(versions) do
-- 				if v:match('^' .. version_prefix) then
-- 					local candidate = zvm_dir .. v .. '/zls'
-- 					if vim.fn.executable(candidate) == 1 then
-- 						zls_path = candidate
-- 						break
-- 					end
-- 				end
-- 			end
-- 		end
-- 	end
--
-- 	return { cmd = { zls_path } }
-- end
--
-- -- Define all of the LSP servers you want, with optional per-server config
-- local servers = {
-- 	clangd = {},
-- 	gopls = {},
-- 	lua_ls = {
-- 		settings = {
-- 			Lua = {
-- 				workspace = { library = vim.api.nvim_get_runtime_file("", true) },
-- 				completion = {
-- 					callSnippet = "Enable",
-- 					keywordSnippet = "Enable",
-- 				},
-- 				diagnostics = { globals = { "vim" } },
-- 			},
-- 		},
-- 	},
-- 	pyright = {},
-- 	ruff = {},
-- 	rust_analyzer = {
-- 		settings = {
-- 			['rust-analyzer'] = {
-- 				completion = {
-- 					callable = {
-- 						snippets = "add_parentheses"
-- 					},
-- 					snippets = {
-- 					},
-- 				},
-- 			}
-- 		},
-- 	},
-- 	ts_ls = {
-- 		cmd = { "typescript-language-server", "--stdio" },
-- 		filetypes = {
-- 			"typescript",
-- 			"typescriptreact",
-- 			"javascript",
-- 			"javascriptreact",
-- 		},
-- 		root_markers = {
-- 			"package.json",
-- 			"tsconfig.json",
-- 			"jsconfig.json",
-- 			".git",
-- 		},
-- 	},
-- 	zls = {
-- 		settings = {
-- 			zls = {},
-- 		},
-- 	},
-- }
--
-- -- Get zls config dynamically
-- local zls_config = get_zls_config()
-- if zls_config then
-- 	servers.zls.cmd = zls_config.cmd
-- end
--
-- for name, cfg in pairs(servers) do
-- 	cfg.capabilities = vim.tbl_deep_extend(
-- 		"force",
-- 		{},
-- 		blink_capabilities,
-- 		cfg.capabilities or {}
-- 	)
--
-- 	vim.lsp.config(name, cfg)
-- end
--
-- vim.lsp.enable(vim.tbl_keys(servers))
--
-- 	-- If it's a dev version, try master first
-- 	if is_dev then
-- 		zls_path = vim.fn.expand('~/.zvm/master/zls')
-- 		if vim.fn.executable(zls_path) == 1 then
-- 			return { cmd = { zls_path } }
-- 		end
-- 	end
--
-- 	-- Try exact version first
-- 	zls_path = vim.fn.expand('~/.zvm/' .. zig_version:match('(%S+)') .. '/zls')
-- 	if vim.fn.executable(zls_path) == 0 then
-- 		-- Try with major.minor.0
-- 		zls_path = vim.fn.expand('~/.zvm/' .. version_prefix .. '.0/zls')
-- 		if vim.fn.executable(zls_path) == 0 then
-- 			-- Fall back to any version in that major.minor range
-- 			local zvm_dir = vim.fn.expand('~/.zvm/')
-- 			local versions = vim.fn.readdir(zvm_dir)
-- 			for _, v in ipairs(versions) do
-- 				if v:match('^' .. version_prefix) then
-- 					local candidate = zvm_dir .. v .. '/zls'
-- 					if vim.fn.executable(candidate) == 1 then
-- 						zls_path = candidate
-- 						break
-- 					end
-- 				end
-- 			end
-- 		end
-- 	end
--
-- 	return { cmd = { zls_path } }
-- end
--
-- -- Define all of the LSP servers you want, with optional per-server config
-- local servers = {
-- 	clangd = {},
-- 	gopls = {},
-- 	lua_ls = {
-- 		settings = {
-- 			Lua = {
-- 				workspace = { library = vim.api.nvim_get_runtime_file("", true) },
-- 				completion = {
-- 					callSnippet = "Enable",
-- 					keywordSnippet = "Enable",
-- 				},
-- 				diagnostics = { globals = { "vim" } },
-- 			},
-- 		},
-- 	},
-- 	pyright = {},
-- 	ruff = {},
-- 	rust_analyzer = {
-- 		settings = {
-- 			['rust-analyzer'] = {
-- 				completion = {
-- 					callable = {
-- 						snippets = "add_parentheses"
-- 					},
-- 					snippets = {
-- 					},
-- 				},
-- 			}
-- 		},
-- 	},
-- 	ts_ls = {
-- 		cmd = { "typescript-language-server", "--stdio" },
-- 		filetypes = {
-- 			"typescript",
-- 			"typescriptreact",
-- 			"javascript",
-- 			"javascriptreact",
-- 		},
-- 		root_markers = {
-- 			"package.json",
-- 			"tsconfig.json",
-- 			"jsconfig.json",
-- 			".git",
-- 		},
-- 	},
-- 	zls = {
-- 		settings = {
-- 			zls = {},
-- 		},
-- 	},
-- }
--
-- -- Get zls config dynamically
-- local zls_config = get_zls_config()
-- if zls_config then
-- 	servers.zls.cmd = zls_config.cmd
-- end
--
-- for name, cfg in pairs(servers) do
-- 	cfg.capabilities = vim.tbl_deep_extend(
-- 		"force",
-- 		{},
-- 		blink_capabilities,
-- 		cfg.capabilities or {}
-- 	)
--
-- 	vim.lsp.config(name, cfg)
-- end
--
-- vim.lsp.enable(vim.tbl_keys(servers))
