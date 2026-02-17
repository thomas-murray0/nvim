vim.pack.add({
	{ src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
})

require 'harpoon'.setup {
	settings = {
		save_on_toggle = true,       -- Save state on window toggle
	},
}
