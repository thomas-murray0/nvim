vim.pack.add({
	{ src = 'https://github.com/nvim-telescope/telescope.nvim',            version = 'master',    name = "telescope" },
	{ src = 'https://github.com/nvim-telescope/telescope-ui-select.nvim',  name = "telescope-ui" },
	{ src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim', name = "telescope-fzf" },
	{ src = 'https://github.com/LinArcX/telescope-env.nvim',               name = "telescope-env" },
	{ src = 'https://github.com/nvim-tree/nvim-web-devicons',              name = "web-devicons" },
})

local telescope = require("telescope")
local themes = require("telescope.themes")

telescope.setup({
	defaults = {
		preview = { treesitter = false },
		color_devicons = true,
		sorting_strategy = "ascending",
		borderchars = {
			"─", -- top
			"│", -- right
			"─", -- bottom
			"│", -- left
			"┌", -- top-left
			"┐", -- top-right
			"┘", -- bottom-right
			"└", -- bottom-left
		},
		path_displays = { "smart" },
		layout_config = {
			height = 100,
			width = 400,
			prompt_position = "top",
			preview_cutoff = 40,
		}
	},
	pickers = {
		-- set defaults here for pickers
		autocommands = {},
		buffers = {
		},
		builtin = {
			use_default_ops = true, -- picker chosen should use its defaults
			-- previewer = false,
		},
		colorscheme = {
			theme = "ivy",
			enable_preview = true,
		},
		command_history = {},
		commands = {},
		current_buffer_fuzzy_find = {},
		current_buffer_tags = {},
		diagnostics = {},
		filetypes = {},
		-- fd is an alias
		find_files = {
			hidden = true,
		},
		git_bcommits = {},
		git_bcommits_range = {},
		git_branches = {},
		git_commits = {},
		git_files = {},
		git_stash = {},
		git_status = {},
		grep_string = {},
		help_tags = {},
		highlights = {},
		jumplist = {},
		keymaps = {},
		live_grep = {},
		loclist = {},
		lsp_definitions = {},
		lsp_document_symbols = {},
		lsp_dynamic_workspace_symbols = {},
		lsp_implementations = {},
		lsp_incoming_calls = {},
		lsp_outgoing_calls = {},
		lsp_references = {},
		lsp_type_definitions = {},
		lsp_workspace_symbols = {},
		man_pages = {},
		marks = {},
		oldfiles = {},
		pickers = {},
		planets = {},
		quickfix = {},
		quickfixhistory = {},
		registers = {},
		reloader = {},
		resume = {},
		search_history = {},
		spell_suggest = {},
		symbols = {},
		tags = {},
		tagstack = {},
		treesitter = {},
		vim_options = {},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	}
})
telescope.load_extension("env")
telescope.load_extension("ui-select")
telescope.load_extension("fzf") -- make sure to make build telescope-fzf-native
