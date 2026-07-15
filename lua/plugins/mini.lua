vim.pack.add({
	{ src = 'https://github.com/nvim-mini/mini.nvim', name = "mini" },
})

-- require 'mini.ai'.setup { n_lines = 500 }
require 'mini.ai'.setup {}
require 'mini.surround'.setup()
-- require 'mini.diff'.setup()

-- some wonky status line
-- local statusline = require 'mini.statusline'
-- statusline.setup{use_icons = vim.g.have_nerd_font}

-- Broken when using :norm some_commands_that_inserts_a_pair
-- require 'mini.pairs'.setup {
-- 	modes = { insert = true, command = false, terminal = false },
--
-- 	-- Global mappings. Each right hand side should be a pair information, a
-- 	-- table with at least these fields (see more in |MiniPairs.map|):
-- 	-- - <action> - one of 'open', 'close', 'closeopen'.
-- 	-- - <pair> - two character string for pair to be used.
-- 	-- By default pair is not inserted after `\`, quotes are not recognized by
-- 	-- <CR>, `'` does not insert pair after a letter.
-- 	-- Only parts of tables can be tweaked (others will use these defaults).
-- 	mappings = {
-- 		['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
-- 		['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
-- 		['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },
--
-- 		[')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
-- 		[']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
-- 		['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },
--
-- 		['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
-- 		["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\].', register = { cr = false } },
-- 		['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
-- 	},
-- }
