return {
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
}
