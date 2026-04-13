vim.pack.add({
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter',            version = 'main' },
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' },
})

require('nvim-treesitter').setup {
  -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
  install_dir = vim.fn.stdpath('data') .. '/site'
}

require('nvim-treesitter').install {
			'bash',
			'c',
			'html',
			'lua',
			'luadoc',
			'markdown',
			'markdown_inline',
			'ocaml',
			'python',
			'rust',
			'zig',
	}

require("nvim-treesitter-textobjects").setup {
  select = {
    -- Automatically jump forward to textobj, similar to targets.vim
    lookahead = true,
    -- You can choose the select mode (default is charwise 'v')
    --
    -- Can also be a function which gets passed a table with the keys
    -- * query_string: eg '@function.inner'
    -- * method: eg 'v' or 'o'
    -- and should return the mode ('v', 'V', or '<c-v>') or a table
    -- mapping query_strings to modes.
    selection_modes = {
      ['@parameter.outer'] = 'v', -- charwise
      ['@function.outer'] = 'V', -- linewise
      -- ['@class.outer'] = '<c-v>', -- blockwise
    },
    -- If you set this to `true` (default is `false`) then any textobject is
    -- extended to include preceding or succeeding whitespace. Succeeding
    -- whitespace has priority in order to act similarly to eg the built-in
    -- `ap`.
    --
    -- Can also be a function which gets passed a table with the keys
    -- * query_string: eg '@function.inner'
    -- * selection_mode: eg 'v'
    -- and should return true of false
    include_surrounding_whitespace = false,
  },
}

-- keymaps
-- You can use the capture groups defined in `textobjects.scm`
vim.keymap.set({ "x", "o" }, "am", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "im", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ac", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ic", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@class.inner", "textobjects")
end)
-- You can also use captures from other query groups like `locals.scm`
vim.keymap.set({ "x", "o" }, "as", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@local.scope", "locals")
end)

-- 				keymaps = {
-- 					-- You can use the capture groups defined in textobjects.scm
-- 					-- seem to be weird lol and I can do it another way probably
-- 					-- ['a='] = { query = '@assignment.outer', desc = 'Select outer part of an assignment' },
-- 					-- ['i='] = { query = '@assignment.inner', desc = 'Select inner part of an assignment' },
-- 					-- ['l='] = { query = '@assignment.lhs', desc = 'Select left hand side of an assignment' },
-- 					-- ['r='] = { query = '@assignment.rhs', desc = 'Select right hand side of an assignment' },
--
-- 					-- seems to be buggy for me as booth do the samefunctionality of selecting up to and including the comma in args
-- 					-- ['aa'] = { query = '@parameter.outer', desc = 'Select outer part of a parameter/argument' },
-- 					-- ['ia'] = { query = '@parameter.inner', desc = 'Select inner part of a parameter/argument' },
--
-- 					['ai'] = { query = '@conditional.outer', desc = 'Select outer part of a conditional' },
-- 					['ii'] = { query = '@conditional.inner', desc = 'Select inner part of a conditional' },
--
-- 					['al'] = { query = '@loop.outer', desc = 'Select outer part of a loop' },
-- 					['il'] = { query = '@loop.inner', desc = 'Select inner part of a loop' },
--
-- 					-- call.* only refers to when a function is called
-- 					-- ['af'] = { query = '@call.outer', desc = 'Select outer part of a function call' },
-- 					-- ['if'] = { query = '@call.inner', desc = 'Select inner part of a function call' },
--
-- 					['af'] = { query = '@function.outer', desc = 'Select outer part of a method/function definition' },
-- 					['if'] = { query = '@function.inner', desc = 'Select inner part of a method/function definition' },
--
-- 					-- potential add some for function calls and maybe one for comments
-- 					-- ['ac'] = { query = '@call.outer', desc = 'Select outer part of a class' },
-- 					-- ['ic'] = { query = '@call.inner', desc = 'Select inner part of a class' },
--
-- 					['ac'] = { query = '@class.outer', desc = 'Select outer part of a class' },
-- 					['ic'] = { query = '@class.inner', desc = 'Select inner part of a class' },
-- 				},
-- 				-- Automatically jump forward to textobj, similar to targets.vim
-- 				lookahead = true,
-- 			},
-- 			swap = {
-- 				enable = true,
-- 				swap_next = {
-- 					['<leader>na'] = { query = '@parameter.inner', desc = 'which_key_ignore' }, --, desc = }, -- swap parameters/argument with next
-- 					['<leader>nf'] = { query = '@function.outer', desc = 'which_key_ignore' }, -- swap function with next
-- 				},
-- 				swap_previous = {
-- 					['<leader>pa'] = { query = '@parameter.inner', desc = 'which_key_ignore' }, -- swap parameters/argument with prev
-- 					['<leader>pf'] = { query = '@function.outer', desc = 'which_key_ignore' }, -- swap function with previous
-- 				},
-- 			},
-- 			move = {
-- 				enable = true,
-- 				set_jumps = true, -- whether to set jumps in the jumplist
-- 				goto_next_start = {
-- 					-- [']f'] = { query = '@call.outer', desc = 'Next function call start' },
-- 					[']f'] = { query = '@function.outer', desc = 'Next method/function def start' },
-- 					[']c'] = { query = '@class.outer', desc = 'Next class start' },
-- 					[']i'] = { query = '@conditional.outer', desc = 'Next conditional start' },
-- 					[']l'] = { query = '@loop.outer', desc = 'Next loop start' },
--
-- 					-- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
-- 					-- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
-- 					[']s'] = { query = '@scope', query_group = 'locals', desc = 'Next scope' },
-- 					[']z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
-- 				},
-- 				goto_next_end = {
-- 					-- [']F'] = { query = '@call.outer', desc = 'Next function call end' },
-- 					[']F'] = { query = '@function.outer', desc = 'Next method/function def end' },
-- 					[']C'] = { query = '@class.outer', desc = 'Next class end' },
-- 					[']I'] = { query = '@conditional.outer', desc = 'Next conditional end' },
-- 					[']L'] = { query = '@loop.outer', desc = 'Next loop end' },
-- 				},
-- 				goto_previous_start = {
-- 					-- ['[f'] = { query = '@call.outer', desc = 'Prev function call start' },
-- 					['[f'] = { query = '@function.outer', desc = 'Prev method/function def start' },
-- 					['[c'] = { query = '@class.outer', desc = 'Prev class start' },
-- 					['[i'] = { query = '@conditional.outer', desc = 'Prev conditional start' },
-- 					['[l'] = { query = '@loop.outer', desc = 'Prev loop start' },
-- 				},
-- 				goto_previous_end = {
-- 					-- ['[F'] = { query = '@call.outer', desc = 'Prev function call end' },
-- 					['[F'] = { query = '@function.outer', desc = 'Prev method/function def end' },
-- 					['[C'] = { query = '@class.outer', desc = 'Prev class end' },
-- 					['[I'] = { query = '@conditional.outer', desc = 'Prev conditional end' },
-- 					['[L'] = { query = '@loop.outer', desc = 'Prev loop end' },


----------------- Old Config --------------------

-- require('nvim-treesitter-textobjects').setup(
-- 	{
-- 		modules = {},
-- 		sync_install = false,
-- 		ignore_install = {},
-- 		auto_install = false,
-- 		ensure_installed = {
-- 			'bash',
-- 			'c',
-- 			'html',
-- 			'lua',
-- 			'luadoc',
-- 			'markdown',
-- 			'markdown_inline',
-- 			'ocaml',
-- 			'python',
-- 			'rust',
-- 			'zig',
-- 		},
-- 		highlight = {
-- 			enable = true,
-- 			additional_vim_regex_highlighting = false,
-- 		},
-- 		indent = {
-- 			enable = true,
-- 		},
-- 		textobjects = {
-- 			select = {
-- 				enable = true,
-- 				keymaps = {
-- 					-- You can use the capture groups defined in textobjects.scm
-- 					-- seem to be weird lol and I can do it another way probably
-- 					-- ['a='] = { query = '@assignment.outer', desc = 'Select outer part of an assignment' },
-- 					-- ['i='] = { query = '@assignment.inner', desc = 'Select inner part of an assignment' },
-- 					-- ['l='] = { query = '@assignment.lhs', desc = 'Select left hand side of an assignment' },
-- 					-- ['r='] = { query = '@assignment.rhs', desc = 'Select right hand side of an assignment' },
--
-- 					-- seems to be buggy for me as booth do the samefunctionality of selecting up to and including the comma in args
-- 					-- ['aa'] = { query = '@parameter.outer', desc = 'Select outer part of a parameter/argument' },
-- 					-- ['ia'] = { query = '@parameter.inner', desc = 'Select inner part of a parameter/argument' },
--
-- 					['ai'] = { query = '@conditional.outer', desc = 'Select outer part of a conditional' },
-- 					['ii'] = { query = '@conditional.inner', desc = 'Select inner part of a conditional' },
--
-- 					['al'] = { query = '@loop.outer', desc = 'Select outer part of a loop' },
-- 					['il'] = { query = '@loop.inner', desc = 'Select inner part of a loop' },
--
-- 					-- call.* only refers to when a function is called
-- 					-- ['af'] = { query = '@call.outer', desc = 'Select outer part of a function call' },
-- 					-- ['if'] = { query = '@call.inner', desc = 'Select inner part of a function call' },
--
-- 					['af'] = { query = '@function.outer', desc = 'Select outer part of a method/function definition' },
-- 					['if'] = { query = '@function.inner', desc = 'Select inner part of a method/function definition' },
--
-- 					-- potential add some for function calls and maybe one for comments
-- 					-- ['ac'] = { query = '@call.outer', desc = 'Select outer part of a class' },
-- 					-- ['ic'] = { query = '@call.inner', desc = 'Select inner part of a class' },
--
-- 					['ac'] = { query = '@class.outer', desc = 'Select outer part of a class' },
-- 					['ic'] = { query = '@class.inner', desc = 'Select inner part of a class' },
-- 				},
-- 				-- Automatically jump forward to textobj, similar to targets.vim
-- 				lookahead = true,
-- 			},
-- 			swap = {
-- 				enable = true,
-- 				swap_next = {
-- 					['<leader>na'] = { query = '@parameter.inner', desc = 'which_key_ignore' }, --, desc = }, -- swap parameters/argument with next
-- 					['<leader>nf'] = { query = '@function.outer', desc = 'which_key_ignore' }, -- swap function with next
-- 				},
-- 				swap_previous = {
-- 					['<leader>pa'] = { query = '@parameter.inner', desc = 'which_key_ignore' }, -- swap parameters/argument with prev
-- 					['<leader>pf'] = { query = '@function.outer', desc = 'which_key_ignore' }, -- swap function with previous
-- 				},
-- 			},
-- 			move = {
-- 				enable = true,
-- 				set_jumps = true, -- whether to set jumps in the jumplist
-- 				goto_next_start = {
-- 					-- [']f'] = { query = '@call.outer', desc = 'Next function call start' },
-- 					[']f'] = { query = '@function.outer', desc = 'Next method/function def start' },
-- 					[']c'] = { query = '@class.outer', desc = 'Next class start' },
-- 					[']i'] = { query = '@conditional.outer', desc = 'Next conditional start' },
-- 					[']l'] = { query = '@loop.outer', desc = 'Next loop start' },
--
-- 					-- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
-- 					-- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
-- 					[']s'] = { query = '@scope', query_group = 'locals', desc = 'Next scope' },
-- 					[']z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
-- 				},
-- 				goto_next_end = {
-- 					-- [']F'] = { query = '@call.outer', desc = 'Next function call end' },
-- 					[']F'] = { query = '@function.outer', desc = 'Next method/function def end' },
-- 					[']C'] = { query = '@class.outer', desc = 'Next class end' },
-- 					[']I'] = { query = '@conditional.outer', desc = 'Next conditional end' },
-- 					[']L'] = { query = '@loop.outer', desc = 'Next loop end' },
-- 				},
-- 				goto_previous_start = {
-- 					-- ['[f'] = { query = '@call.outer', desc = 'Prev function call start' },
-- 					['[f'] = { query = '@function.outer', desc = 'Prev method/function def start' },
-- 					['[c'] = { query = '@class.outer', desc = 'Prev class start' },
-- 					['[i'] = { query = '@conditional.outer', desc = 'Prev conditional start' },
-- 					['[l'] = { query = '@loop.outer', desc = 'Prev loop start' },
-- 				},
-- 				goto_previous_end = {
-- 					-- ['[F'] = { query = '@call.outer', desc = 'Prev function call end' },
-- 					['[F'] = { query = '@function.outer', desc = 'Prev method/function def end' },
-- 					['[C'] = { query = '@class.outer', desc = 'Prev class end' },
-- 					['[I'] = { query = '@conditional.outer', desc = 'Prev conditional end' },
-- 					['[L'] = { query = '@loop.outer', desc = 'Prev loop end' },
-- 				},
-- 			},
-- 		},
-- 	}
-- )
