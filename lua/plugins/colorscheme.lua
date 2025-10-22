vim.pack.add({
	{ src = 'https://github.com/catppuccin/nvim',    name = 'catppuccin' },
	{ src = 'https://github.com/kuri-sun/yoda.nvim', 'yoda' },
})

-- sets colorscheme
vim.cmd('colorscheme yoda')
