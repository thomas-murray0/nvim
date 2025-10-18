vim.pack.add({
	{ src = 'https://github.com/nvim-mini/mini.nvim', name = "mini"},
})

-- require 'mini.ai'.setup { n_lines = 500 }
require 'mini.ai'.setup {}
require 'mini.surround'.setup()
require 'mini.pairs'.setup()
-- require 'mini.diff'.setup()

-- some wonky status line
-- local statusline = require 'mini.statusline'
-- statusline.setup{use_icons = vim.g.have_nerd_font}
