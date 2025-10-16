vim.pack.add({
	{ src = 'https://github.com/stevearc/oil.nvim', name = "oil"},
})

require 'oil'.setup({
	-- disabling columns, else file icon shows up without this
	 columns = {
    -- "icon",
    -- "permissions",
    -- "size",
    -- "mtime",
  },
	use_default_keymaps = false,
	keymaps = {
		["<CR>"] = "actions.select",
		["g."] = { "actions.toggle_hidden", mode = "n" },
		["-"] = { "actions.parent", mode = "n" },
		["_"] = { "actions.open_cwd", mode = "n" },
	},
	view_options = {
		show_hidden = false,
	},
})
