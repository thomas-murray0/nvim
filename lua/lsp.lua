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
                        ['rust-analyzer'] = {}
                }
        },
        -- 	settings = {
        -- 		['rust-analyzer'] = {
        -- 			completion = {
        -- 				callable = {
        -- 					snippets = "add_parentheses"
        -- 				},
        -- 				snippets = {
        -- 				},
        -- 			},
        -- 		}
        -- 	},
        -- },
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
                cmd = { vim.fn.expand('~/.zvm/bin/zls') },
                settings = {
                        zls = {

                                -- "description": "Enables snippet completions when the client also supports them",
                                -- "type": "bool",
                                enable_snippets = true,

                                -- "description": "Whether to enable function argument placeholder completions",
                                -- "type": "bool",
                                enable_argument_placeholders = true,

                                -- "description": "Whether to show the function signature in completion results. May improve readability in some editors when disabled",
                                -- "type": "bool",
                                completion_label_details = true,

                                -- "description": "Whether to enable build-on-save diagnostics. Will be automatically enabled if the `build.zig` has declared a 'check' step.\n\nFor more infromation, checkout the [Build-On-Save](https://zigtools.org/zls/guides/build-on-save/) Guide.",
                                -- "type": "?bool",
                                -- enable_build_on_save = nil,

                                -- "description": "Specify which arguments should be passed to Zig when running build-on-save.\n\nIf the `build.zig` has declared a 'check' step, it will be preferred over the default 'install' step.",
                                -- "type": "[]const []const u8",
                                -- build_on_save_args = [],

                                -- "description": "Set level of semantic tokens. `partial` only includes information that requires semantic analysis.",
                                -- "type": "enum", "enum": [ "none", "partial", "full" ],
                                semantic_tokens = "full",

                                -- "description": "Enable inlay hints for variable types",
                                -- "type": "bool",
                                inlay_hints_show_variable_type_hints = true,

                                -- "description": "Enable inlay hints for fields in struct and union literals",
                                -- "type": "bool",
                                inlay_hints_show_struct_literal_field_type = true,

                                -- "description": "Enable inlay hints for parameter names",
                                -- "type": "bool",
                                inlay_hints_show_parameter_name = true,

                                -- "description": "Enable inlay hints for builtin functions",
                                -- "type": "bool",
                                inlay_hints_show_builtin = true,

                                -- "description": "Don't show inlay hints for single argument calls",
                                -- "type": "bool",
                                inlay_hints_exclude_single_argument = true,

                                -- "description": "Hides inlay hints when parameter name matches the identifier (e.g. `foo: foo`)",
                                -- "type": "bool",
                                inlay_hints_hide_redundant_param_names = false,

                                -- "description": "Hides inlay hints when parameter name matches the last token of a parameter node (e.g. `foo: bar.foo`, `foo: &foo`)",
                                -- "type": "bool",
                                inlay_hints_hide_redundant_param_names_last_token = false,

                                -- "description": "Work around editors that do not support 'source.fixall' code actions on save. This option may delivered a substandard user experience. Please refer to the installation guide to see which editors natively support code actions on save.",
                                -- "type": "bool",
                                force_autofix = true,

                                -- "description": "Enables warnings for style guideline mismatches",
                                -- "type": "bool",
                                warn_style = true,

                                -- "description": "Whether to highlight global var declarations",
                                -- "type": "bool",
                                highlight_global_var_declarations = true,

                                -- "description": "No longer used. May be brought back to configure how symbol references in the standard library should behave",
                                -- "type": "bool",
                                -- skip_std_references = false,

                                -- "description": "Favor using `zig ast-check` instead of the builtin one",
                                -- "type": "bool",
                                prefer_ast_check_as_child_process = true,

                                -- "description": "Override the path to 'builtin' module. Automatically resolved if unset.",
                                -- "type": "?[]const u8",
                                -- builtin_path = null,

                                -- "description": "Override the Zig library path. Will be automatically resolved using the 'zig_exe_path'.",
                                -- "type": "?[]const u8",
                                -- zig_lib_path = null,

                                -- "description": "Specify the path to the Zig executable (not the directory). If unset, zig is looked up in `PATH`. e.g. `/path/to/zig-templeos-armless-1.0.0/zig`.",
                                -- "type": "?[]const u8",
                                -- zig_exe_path = null,

                                -- "description": "Specify a custom build runner to resolve build system information.",
                                -- "type": "?[]const u8",
                                -- build_runner_path = null,

                                -- "description": "Path to a directory that will be used as zig's cache. Will default to `${KnownFolders.Cache}/zls`.",
                                -- "type": "?[]const u8",
                                -- global_cache_path = null,
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
