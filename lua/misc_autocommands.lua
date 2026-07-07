-- ============================================================================
-- Autocommands
-- ============================================================================
-- Notes:
-- - Every autocmd is placed in its own augroup for easy maintenance.
-- - Most autocmds have a `desc` so `:autocmd` output is readable.
-- - A few blocks are slightly opinionated; comment them out if you dislike
--   the behavior.
-- ============================================================================

local function augroup(name)
        return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

local save_flash_ns = vim.api.nvim_create_namespace("user_save_flash")

-- Custom highlight group used by the yank highlight autocmd below.
vim.api.nvim_set_hl(0, "YankHighlight", {
        bg = "#8839ef",
        fg = "NONE",
})

-- Custom highlight group used by the "save flash" autocmd below.
vim.api.nvim_set_hl(0, "SaveFlash", {
        bg = "#3b4252",
        fg = "NONE",
})

-- Highlight text briefly after yanking so it is obvious what was copied.
vim.api.nvim_create_autocmd("TextYankPost", {
        group = augroup("highlight_yank"),
        desc = "Highlight text that was just yanked",
        callback = function()
                vim.highlight.on_yank({
                        higroup = "YankHighlight",
                        timeout = 75,
                })
        end,
})

-- Briefly flash the current line after saving to give visual confirmation.
vim.api.nvim_create_autocmd("BufWritePost", {
        group = augroup("save_flash"),
        desc = "Briefly flash the current line after save",
        callback = function(args)
                local cursor = vim.api.nvim_win_get_cursor(0)
                local row = cursor[1] - 1

                vim.api.nvim_buf_clear_namespace(args.buf, save_flash_ns, 0, -1)
                vim.api.nvim_buf_add_highlight(
                        args.buf,
                        save_flash_ns,
                        "SaveFlash",
                        row,
                        0,
                        -1
                )

                vim.defer_fn(function()
                        if vim.api.nvim_buf_is_valid(args.buf) then
                                vim.api.nvim_buf_clear_namespace(args.buf, save_flash_ns, 0, -1)
                        end
                end, 80)
        end,
})

-- Check whether files changed outside Neovim whenever you return focus.
-- This helps when using git, external formatters, generators, or another
-- editor/terminal.
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
        group = augroup("checktime"),
        desc = "Reload files changed outside Neovim",
        callback = function()
                if vim.fn.mode() == "c" then
                        return
                end

                if vim.bo.buftype ~= "" then
                        return
                end

                vim.cmd("checktime")
        end,
})

-- Rebalance splits when the terminal window is resized.
vim.api.nvim_create_autocmd("VimResized", {
        group = augroup("resize_splits"),
        desc = "Resize splits evenly after terminal resize",
        callback = function()
                vim.cmd("tabdo wincmd =")
        end,
})

-- Restore the cursor to the last known position when reopening a file.
-- Skips temporary/special filetypes where this is usually annoying.
vim.api.nvim_create_autocmd("BufReadPost", {
        group = augroup("restore_cursor"),
        desc = "Restore cursor to last position when reopening a file",
        callback = function(args)
                local excluded_filetypes = {
                        "commit",
                        "gitcommit",
                        "gitrebase",
                        "help",
                        "qf",
                }

                if vim.tbl_contains(excluded_filetypes, vim.bo[args.buf].filetype) then
                        return
                end

                local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
                local line_count = vim.api.nvim_buf_line_count(args.buf)

                if mark[1] > 0 and mark[1] <= line_count then
                        pcall(vim.api.nvim_win_set_cursor, 0, mark)
                end
        end,
})

-- Automatically create missing parent directories before saving a file.
-- Example: editing `foo/bar/baz.txt` will create `foo/bar/` if needed.
vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup("auto_create_dir"),
        desc = "Create missing parent directories before save",
        callback = function(args)
                local file = vim.api.nvim_buf_get_name(args.buf)

                if file == "" then
                        return
                end

                -- Skip URIs and special buffers.
                if file:match("^%w+://") or file:match("^term://") then
                        return
                end

                local dir = vim.fn.fnamemodify(file, ":p:h")
                if vim.fn.isdirectory(dir) == 0 then
                        vim.fn.mkdir(dir, "p")
                end
        end,
})

-- Turn on a more pleasant "writing mode" for prose-like filetypes.
-- This keeps your global code defaults intact while making markdown and
-- commit messages easier to edit.
vim.api.nvim_create_autocmd("FileType", {
        group = augroup("prose_settings"),
        desc = "Enable wrap, linebreak, and spell for prose filetypes",
        pattern = { "markdown", "text", "gitcommit" },
        callback = function(args)
                vim.bo[args.buf].spell = true
                vim.opt_local.wrap = true
                vim.opt_local.linebreak = true
                vim.opt_local.breakindent = true

                if vim.bo[args.buf].filetype == "gitcommit" then
                        vim.opt_local.textwidth = 72
                        vim.opt_local.colorcolumn = "73"
                else
                        vim.opt_local.textwidth = 80
                        vim.opt_local.colorcolumn = "81"
                end
        end,
})

-- Make temporary/special buffers easy to close with `q`.
-- Also hides them from normal buffer lists.
vim.api.nvim_create_autocmd("FileType", {
        group = augroup("close_with_q"),
        desc = "Close special windows with q",
        pattern = {
                "help",
                "lspinfo",
                "man",
                "qf",
                "checkhealth",
                "startuptime",
                "query",
                "tsplayground",
        },
        callback = function(args)
                vim.bo[args.buf].buflisted = false

                vim.keymap.set("n", "q", "<cmd>close<CR>", {
                        buffer = args.buf,
                        silent = true,
                        desc = "Close window",
                })
        end,
})

-- Set cleaner defaults for terminal buffers.
-- Removes line numbers/signcolumn and jumps straight into insert mode.
vim.api.nvim_create_autocmd("TermOpen", {
        group = augroup("terminal_defaults"),
        desc = "Use cleaner local settings for terminal buffers",
        callback = function()
                vim.opt_local.number = false
                vim.opt_local.relativenumber = false
                vim.opt_local.signcolumn = "no"
                vim.opt_local.wrap = false
                vim.cmd("startinsert")
        end,
})

-- Mark very large files and disable some expensive features for them.
-- This prevents big logs/generated files from feeling sluggish.
vim.api.nvim_create_autocmd("BufReadPre", {
        group = augroup("large_file"),
        desc = "Disable expensive features for very large files",
        callback = function(args)
                local file = vim.api.nvim_buf_get_name(args.buf)
                if file == "" then
                        return
                end

                local ok, stat = pcall(vim.uv.fs_stat, file)
                if not ok or not stat then
                        return
                end

                -- 1 MiB threshold. Adjust if you want.
                if stat.size > 1024 * 1024 then
                        vim.b[args.buf].large_file = true
                        vim.bo[args.buf].swapfile = false
                        vim.opt_local.foldmethod = "manual"
                        vim.opt_local.spell = false
                        vim.opt_local.wrap = false
                end
        end,
})

-- Actually start Treesitter highlighting/features for supported filetypes.
-- This is especially useful with your Neovim 0.12 + nvim-treesitter setup.
-- Large files are skipped to avoid lag.
vim.api.nvim_create_autocmd("FileType", {
        group = augroup("treesitter_start"),
        desc = "Start Treesitter for supported filetypes",
        pattern = {
                "bash",
                "c",
                "html",
                "javascript",
                "javascriptreact",
                "lua",
                "luadoc",
                "markdown",
                "markdown_inline",
                "ocaml",
                "python",
                "rust",
                "typescript",
                "typescriptreact",
                "vim",
                "vimdoc",
                "query",
                "zig",
        },
        callback = function(args)
                if vim.b[args.buf].large_file then
                        return
                end

                pcall(vim.treesitter.start, args.buf)
        end,
})

-- Disable automatic comment continuation when pressing Enter or using `o/O`.
-- Many people prefer this because it avoids "comment spam" while editing.
vim.api.nvim_create_autocmd("BufEnter", {
        group = augroup("stop_comment_continuation"),
        desc = "Do not continue comments automatically on newline",
        callback = function()
                vim.opt_local.formatoptions:remove({ "c", "r", "o" })
        end,
})

-- Trim trailing whitespace on save for common code/config filetypes.
-- Keeps diffs cleaner without touching prose or special file formats.
vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup("trim_trailing_whitespace"),
        desc = "Trim trailing whitespace on save for code-like files",
        pattern = {
                "*.c",
                "*.cpp",
                "*.go",
                "*.h",
                "*.hpp",
                "*.js",
                "*.jsx",
                "*.lua",
                "*.py",
                "*.rs",
                "*.ts",
                "*.tsx",
                "*.vim",
                "*.zig",
        },
        callback = function()
                local view = vim.fn.winsaveview()
                vim.cmd([[silent! keepjumps keeppatterns %s/\s\+$//e]])
                vim.fn.winrestview(view)
        end,
})

-- Open the quickfix window automatically after commands that populate it,
-- but only if there are actually entries to show.
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
        group = augroup("quickfix_auto_open"),
        desc = "Open quickfix window when a command produces quickfix entries",
        pattern = { "make", "grep", "vimgrep", "helpgrep" },
        callback = function()
                local qf = vim.fn.getqflist({ size = 0 })
                if qf.size > 0 then
                        vim.cmd("cwindow")
                end
        end,
})

-- Toggle relative line numbers off in insert mode and back on in normal mode.
-- This keeps motion-friendly numbers in normal mode while simplifying insert.
vim.api.nvim_create_autocmd("InsertEnter", {
        group = augroup("relative_number_insert"),
        desc = "Disable relative number while typing in insert mode",
        callback = function()
                if vim.wo.number then
                        vim.wo.relativenumber = false
                end
        end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
        group = augroup("relative_number_normal"),
        desc = "Re-enable relative number after leaving insert mode",
        callback = function()
                if vim.wo.number then
                        vim.wo.relativenumber = true
                end
        end,
})

-- Give help pages and man pages a consistent layout by opening them on the
-- right side of the screen.
vim.api.nvim_create_autocmd("FileType", {
        group = augroup("help_window_layout"),
        desc = "Move help and man pages to a right-hand vertical split",
        pattern = { "help", "man" },
        callback = function()
                vim.cmd("wincmd L")
        end,
})

-- Lazily load Markview the first time a markdown buffer is opened.
-- This avoids paying startup cost for a markdown-only plugin.
vim.api.nvim_create_autocmd("FileType", {
        group = augroup("lazy_markview"),
        desc = "Load Markview only when editing markdown",
        pattern = { "markdown" },
        once = true,
        callback = function()
                pcall(function()
                        require("lazy.markview").ensure()
                end)
        end,
})

-- LSP attach handler:
-- - document highlighting when the server supports it
-- - inlay hints when supported
-- - extra protection for large files
vim.api.nvim_create_autocmd("LspAttach", {
        group = augroup("lsp_attach"),
        desc = "Set up buffer-local LSP behavior when a client attaches",
        callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if not client then
                        return
                end

                -- On large files, disable some heavier LSP visual features.
                if vim.b[args.buf].large_file then
                        pcall(vim.lsp.inlay_hint.enable, false, { bufnr = args.buf })

                        if client.server_capabilities.semanticTokensProvider then
                                pcall(vim.lsp.semantic_tokens.stop, args.buf, client.id)
                        end
                end

                -- Enable inlay hints automatically when the server supports them.
                if client:supports_method(
                            vim.lsp.protocol.Methods.textDocument_inlayHint
                    ) and not vim.b[args.buf].large_file then
                        pcall(vim.lsp.inlay_hint.enable, true, { bufnr = args.buf })
                end

                -- Highlight references under cursor on CursorHold if supported.
                if client:supports_method(
                            vim.lsp.protocol.Methods.textDocument_documentHighlight
                    ) then
                        local group = vim.api.nvim_create_augroup(
                                "user_lsp_highlight_" .. args.buf,
                                { clear = true }
                        )

                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                                group = group,
                                buffer = args.buf,
                                desc = "Highlight symbol references under cursor",
                                callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                                group = group,
                                buffer = args.buf,
                                desc = "Clear LSP reference highlights when cursor moves",
                                callback = vim.lsp.buf.clear_references,
                        })

                        vim.api.nvim_create_autocmd("LspDetach", {
                                group = group,
                                buffer = args.buf,
                                desc = "Clean up LSP highlights on detach",
                                callback = function()
                                        vim.lsp.buf.clear_references()
                                        pcall(vim.api.nvim_del_augroup_by_id, group)
                                end,
                        })
                end
        end,
})
