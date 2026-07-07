vim.api.nvim_create_autocmd('TextYankPost', {
        desc = 'Highlight text that is yanked',
        group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
        callback = function()
                vim.highlight.on_yank {
                        -- sets custom yank color
                        higroup = 'YankHighlight', -- your custom group name
                        timeout = 75,              -- duration in ms
                }
        end,
})
vim.api.nvim_set_hl(0, 'YankHighlight', { bg = '#8839ef', fg = 'NONE' })

--  This gets run when an LSP attaches to a particular buffer.
local lsp_attach_group = vim.api.nvim_create_augroup("lsp-attach", { clear = true })
local lsp_highlight_group = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

vim.api.nvim_create_autocmd("LspAttach", {
        group = lsp_attach_group,
        callback = function(event)
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if not client then
                        return
                end

                if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                                group = lsp_highlight_group,
                                buffer = event.buf,
                                callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                                group = lsp_highlight_group,
                                buffer = event.buf,
                                callback = vim.lsp.buf.clear_references,
                        })

                        vim.api.nvim_create_autocmd("LspDetach", {
                                buffer = event.buf,
                                callback = function()
                                        vim.lsp.buf.clear_references()
                                        vim.api.nvim_clear_autocmds({
                                                group = lsp_highlight_group,
                                                buffer = event.buf,
                                        })
                                end,
                        })
                end
        end,
})

-- OLD --

--  This function gets run when an LSP attaches to a particular buffer.
-- vim.api.nvim_create_autocmd('LspAttach', {
--         group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
--         callback = function(event)
--                 -- The following two autocommands are used to highlight references of the
--                 -- word under your cursor when your cursor rests there for a little while.
--                 -- When you move your cursor, the highlights will be cleared (the second autocommand).
--                 local client = vim.lsp.get_client_by_id(event.data.client_id)
--                 if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
--                         local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
--                         vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
--                                 buffer = event.buf,
--                                 group = highlight_augroup,
--                                 callback = vim.lsp.buf.document_highlight,
--                         })
--
--                         vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
--                                 buffer = event.buf,
--                                 group = highlight_augroup,
--                                 callback = vim.lsp.buf.clear_references,
--                         })
--
--                         vim.api.nvim_create_autocmd('LspDetach', {
--                                 group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
--                                 callback = function(event2)
--                                         vim.lsp.buf.clear_references()
--                                         vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
--                                 end,
--                         })
--                 end
--         end,
-- })

-- Start Treesitter w/ large file protection --
vim.api.nvim_create_autocmd("FileType", {
        pattern = { "*" },
        callback = function(args)
                local name = vim.api.nvim_buf_get_name(args.buf)
                local ok, stat = pcall(vim.uv.fs_stat, name)
                if ok and stat and stat.size > 200 * 1024 then
                        return
                end
                pcall(vim.treesitter.start, args.buf)
        end,
})
