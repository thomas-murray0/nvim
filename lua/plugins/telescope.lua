vim.pack.add({
	{ src = 'https://github.com/nvim-telescope/telescope.nvim',            version = 'master',     name = "telescope"},
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
		find_files = {
			hidden = true,
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		}
	}
})
telescope.load_extension("ui-select")
telescope.load_extension("fzf") -- make sure to make build telescope-fzf-native
