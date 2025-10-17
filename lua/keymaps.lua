local map = vim.keymap.set

-- Neovim --
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

map('n', '<leader>so', ':source<CR>')
-- LSP --
map('n', '<leader>lf', vim.lsp.buf.format, { desc = "LSP Format" })
map('n', '<leader>lr', vim.lsp.buf.rename, { desc = 'LSP Rename' })

local builtin = require('telescope.builtin')
map('n', 'gd', builtin.lsp_definitions, { desc = "Goto definition" })

map('n', 'gr', builtin.lsp_references, { desc = 'Goto references' })
map('n', 'gI', builtin.lsp_implementations, { desc = 'Goto Implementation' })
-- what is a code action?
-- map('n', '<leader>la', vim.lsp.buf.code_action, { desc = 'Code Action' })
map('n', 'gD', vim.lsp.buf.declaration, { desc = 'Goto declaration' })

--- Plugins ---

-- Oil --
map('n', '-', ':Oil<CR>')
-- Additional Keymaps setup in ~/.config/nvim/lua/plugins/oil.lua

-- Tmux Nav --
map('n', '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>')
map('n', '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>')
map('n', '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>')
map('n', '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>')
map('n', '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>')

-- Telescope --
map('n', '<leader>sh', builtin.help_tags, { desc = 'Search Help' })
map('n', '<leader>sk', builtin.keymaps, { desc = 'Search Keymaps' })
map('n', '<leader>sf', builtin.find_files, { desc = 'Search Files' })
map('n', '<leader>st', builtin.builtin, { desc = 'Search Telescope' })
map('n', '<leader>sw', builtin.grep_string, { desc = 'Search current Word' })
map('n', '<leader>sg', builtin.live_grep, { desc = 'Search by Grep' })
map('n', '<leader>sd', builtin.diagnostics, { desc = 'Search Diagnostics' })
map('n', '<leader>sr', builtin.resume, { desc = 'Search Resume' })
map('n', '<leader>s.', builtin.oldfiles, { desc = 'Search Recent Files ("." for repeat)' })
map('n', '<leader><leader>', builtin.buffers, { desc = 'Find existing buffers' })

-- map('n', '<leader>someDopeMapping', builtin.buffers, { desc = 'Search Files in Another Directory' })

map('n', '<leader>/', function()
	builtin.current_buffer_fuzzy_find()
end, { desc = '/ Fuzzily search in current buffer' })

map('n', '<leader>sn', function()
	builtin.find_files {
		cwd = vim.fn.stdpath 'config',
		prompt_title = "Search Neovim Files",
	}
end, { desc = 'Search Neovim files' })

-- Harpoon --
local harpoon = require 'harpoon'

map('n', '<leader>ha', function()
	harpoon:list():add()
end, { desc = 'Add File to Harpoon' })

map('n', '<leader>hr', function()
	harpoon:list():remove()
end, { desc = 'Remove File from Harpoon' })
--
map('n', '<leader>hl', function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = 'List Harpoon Files' })

map('n', '[h', function()
	harpoon:list():prev { ui_nav_wrap = true }
end, { desc = 'Previous Harpoon File' })

map('n', ']h', function()
	harpoon:list():next { ui_nav_wrap = true }
end, { desc = 'Next Harpoon File' })

map('n', '<leader>hc', function()
	harpoon:list():clear()
end, { desc = 'Clear Harpoon List' })

for i = 1, 9 do
	map('n', string.format('<leader>h%s', i), function()
		harpoon:list():select(i)
	end, { desc = string.format('Jump to Harpoon File %s', i) })
end

-- LuaSnip --
local ls = require("luasnip")

map({ "i" }, "<C-K>", function() ls.expand() end, { silent = true })
map({ "i", "s" }, "<C-L>", function() ls.jump(1) end, { silent = true })
map({ "i", "s" }, "<C-J>", function() ls.jump(-1) end, { silent = true })

-- Misc --

-- Creates a Telescope window containing all packages in vim.pack.get()
map('n', '<leader>lp', function()
	local pickers = require('telescope.pickers')
	local finders = require('telescope.finders')
	local conf = require('telescope.config').values
	local entry_display = require('telescope.pickers.entry_display')
	local actions = require('telescope.actions')
	local action_state = require('telescope.actions.state')

	local plugins = vim.pack.get()

	local displayer = entry_display.create({
		separator = " ",
		items = {
			{ width = 30 },
			{ width = 10 },
			{ width = 75 },
		},
	})

	local function make_display(entry)
		local hl = entry.active and "TelescopeResultsIdentifier"
				or "TelescopeResultsComment"
		return displayer({
			{ entry.name,   "TelescopeResultsFunction" },
			{ entry.status, hl },
			{ entry.path,   "TelescopeResultsComment" },
		})
	end

	local entries = {}
	for _, p in ipairs(plugins) do
		table.insert(entries, {
			value = p,
			name = p.spec.name or "Unknown",
			status = p.active and "[Active]" or "[Inactive]",
			path = p.spec.src,
			active = p.active,
			display = make_display,
			ordinal = (p.spec.name or "") .. " " .. p.path,
		})
	end

	pickers
			.new({}, {
				prompt_title = "Installed Plugins",
				finder = finders.new_table {
					results = entries,
					entry_maker = function(entry) return entry end,
				},
				sorter = conf.generic_sorter({}),
				attach_mappings = function(_, mapp)
					mapp("i", "<esc>", actions.close)
					mapp("n", "<esc>", actions.close)
					mapp("i", "<CR>", function(prompt_bufnr)
						local selection = action_state.get_selected_entry()
						actions.close(prompt_bufnr)
						vim.notify(selection.name, vim.log.levels.INFO)
					end)
					return true
				end,
			})
			:find()
end, { desc = "List All Packages (telescope)" })

-- Creates a scratch tab split with all plugins from vim.pack.get()
-- Allows for macro vim.pack.del() or .update()
map('n', '<leader>lt', function()
  local plugins = vim.pack.get()
  local lines = {}
  table.insert(lines, '=== Installed Plugins ===')
  table.insert(lines, '')

  for _, p in ipairs(plugins) do
    local src = p.spec.src or 'Unknown'
    local name = p.spec.name or 'Unknown'
    local path = p.path or 'Unknown'
    local active = p.active and 'Yes' or 'No'
    local file = p.spec.file or 'Unknown'

    table.insert(lines, string.format('Name: %s', name))
    table.insert(lines, string.format('Active: %s', active))
    table.insert(lines, string.format('Source: %s', src))
    table.insert(lines, string.format('Path:   %s', path))
    table.insert(lines, string.format('Added from: %s', file))
    table.insert(lines, '')
  end

  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = buf })
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')

  vim.cmd('split')
  vim.api.nvim_win_set_buf(0, buf)

  vim.api.nvim_set_hl(0, 'PluginHeader', { fg = '#89b4fa', bold = true })
  vim.api.nvim_buf_add_highlight(buf, -1, 'PluginHeader', 0, 0, -1)
end, { desc = 'List All Packages (buffer)' })
