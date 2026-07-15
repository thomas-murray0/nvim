local blink_capabilities = require('blink.cmp').get_lsp_capabilities()

-- Define all of the LSP servers you want, with optional per-server config
local servers = {
        clangd = {},
        gopls = {},
        lua_ls = require("lsp.lua_ls"),
        pyright = {},
        ruff = {},
        rust_analyzer = {
                settings = {
                        ['rust-analyzer'] = {}
                }
        },
        ts_ls = require("lsp.typescript"),
        zls = require("lsp.zig"),
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
