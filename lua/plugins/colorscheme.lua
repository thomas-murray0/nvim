vim.pack.add({
	{ src = 'https://github.com/catppuccin/nvim',              name = 'catppuccin' },
	{ src = 'https://github.com/kuri-sun/yoda.nvim',           name = 'yoda' },
	{ src = 'https://github.com/ellisonleao/gruvbox.nvim',     name = 'gruvbox' },
	{ src = 'https://github.com/folke/tokyonight.nvim',        name = 'tokyo-night' },
	{ src = 'https://github.com/dgox16/oldworld.nvim',         name = 'oldworld' },
	{ src = 'https://github.com/Mofiqul/dracula.nvim',         name = 'dracula' },
	{ src = 'https://github.com/xero/miasma.nvim',             name = 'miasma' },
	{ src = 'https://github.com/rebelot/kanagawa.nvim',        name = 'kanagawa' },
	{ src = 'https://github.com/Mofiqul/vscode.nvim',          name = 'vscode' },
	{ src = 'https://github.com/shaunsingh/nord.nvim',         name = 'nord' },
	{ src = 'https://github.com/eldritch-theme/eldritch.nvim', name = 'eldritch' },
	{ src = 'https://github.com/rose-pine/neovim',             name = 'rose-pine' },
})

require("catppuccin").setup({
    flavour = "auto", -- latte, frappe, macchiato, mocha
    background = { -- :h background
        light = "latte",
        dark = "mocha",
    },
    transparent_background = false, -- disables setting the background color.
    float = {
        transparent = false, -- enable transparent floating windows
        solid = false, -- use solid styling for floating windows, see |winborder|
    },
    show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
    term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = {}, -- Change the style of comments
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
        -- miscs = {}, -- Uncomment to turn off hard-coded styles
    },
    lsp_styles = { -- Handles the style of specific lsp hl groups (see `:h lsp-highlight`).
        virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
            ok = { "italic" },
        },
        underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
            ok = { "underline" },
        },
        inlay_hints = {
            background = true,
        },
    },
    color_overrides = {},
    custom_highlights = {},
    default_integrations = true,
    auto_integrations = false,
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        notify = false,
        mini = {
            enabled = true,
            indentscope_color = "",
        },
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
})

-- sets colorscheme
vim.cmd('colorscheme catppuccin')
