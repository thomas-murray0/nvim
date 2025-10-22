local map = vim.keymap.set

-- Neovim --
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

map('n', '<leader>so', ':source ~/.config/nvim/init.lua<CR>')

-- LSP --
map('n', '<leader>lf', vim.lsp.buf.format, { desc = "LSP Format" })
map('n', '<leader>lr', vim.lsp.buf.rename, { desc = 'LSP Rename' })

local builtin = require('telescope.builtin')
map('n', 'gD', vim.lsp.buf.declaration, { desc = 'Goto declaration' })
map('n', 'gd', builtin.lsp_definitions, { desc = "Goto definition" })

map('n', 'gr', builtin.lsp_references, { desc = 'Goto references' })
map('n', 'gI', builtin.lsp_implementations, { desc = 'Goto Implementation' })

map('n', '<leader>la', vim.lsp.buf.code_action, { desc = 'Code Action' })

--- Plugins ---

-- Blink --
-- Keymaps setup in ~/.config/nvim/lua/plugins/blink.lua

-- Treesitter --
-- Textobject keymaps setup in ~/.config/nvim/lua/plugins/treesitter.lua

-- Oil --
map('n', '-', ':Oil<CR>')
-- Additional keymaps setup in ~/.config/nvim/lua/plugins/oil.lua

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
map('n', '<leader>sw', builtin.grep_string, { desc = 'Search current word' })
map('n', '<leader>sg', builtin.live_grep, { desc = 'Search by Grep' })
map('n', '<leader>sd', builtin.diagnostics, { desc = 'Search Diagnostics' })
map('n', '<leader>sr', builtin.registers, { desc = 'Search Registers' })
map('n', '<leader>s.', builtin.oldfiles, { desc = 'Search Recent Files ("." for repeat)' })
map('n', '<leader>sq', builtin.quickfix, { desc = 'Search in Quickfix List' })
map('n', '<leader>sb', builtin.buffers, { desc = 'Search existing Buffers' })
map('n', '<leader>se', "<cmd>Telescope env<CR>", { desc = 'Search Environment variables' })

map('n', '<leader>/', function()
	builtin.current_buffer_fuzzy_find()
end, { desc = '/ Fuzzily search in current buffer' })

map('n', '<leader>sn', function()
	builtin.find_files {
		cwd = vim.fn.stdpath 'config',
		prompt_title = "Search Neovim Files",
	}
end, { desc = 'Search Neovim files' })

--- <<< START find_files_with_path
vim.keymap.set("n", "<leader>spf", function()
  local home = vim.fn.expand("~") -- resolves to $HOME
  vim.ui.input({
    prompt = "Search files in directory: ",
    default = home .. "/",
    completion = "dir",
  }, function(dir)
    if not dir or dir == "" then
      return
    end
    dir = vim.fn.expand(dir)

    if vim.fn.isdirectory(dir) == 0 then
      vim.notify(("Not a directory: %s"):format(dir), vim.log.levels.WARN)
      return
    end

    builtin.find_files({
      cwd = dir,
      hidden = true,   -- toggle as needed
      no_ignore = true, -- uncomment if you want to include ignored files
    })
  end)
end, { desc = "Search a Path's Files" })
--- find_files_with_path END >>>

-- <<< live_grep_with_args START
local function parse_args(argline)
	-- Returns:
	--   glob_pattern: nil | string | table
	--   type_filter: nil | string  (single include type)
	--   additional_args: nil | table (for --type-not and extras)
	--
	-- Supports:
	--   -g PATTERN | --glob PATTERN | -gPATTERN | --glob=PATTERN
	--   -tTYPE | --type TYPE | --type=TYPE
	--   -T TYPE | --type-not TYPE | --type-not=TYPE
	-- Shorthands:
	--   -t<name>  (e.g. -trust)
	--   -T<name>  (e.g. -Trust)

	if not argline or argline == "" then
		return nil, nil, nil
	end

	local tokens = {}
	-- Simple shell-like split on whitespace
	for tok in argline:gmatch("%S+") do
		table.insert(tokens, tok)
	end

	local globs = {}
	local type_include = nil
	local extra = {}

	local i = 1
	while i <= #tokens do
		local tok = tokens[i]

		-- --glob=PATTERN
		local glob_eq = tok:match("^%-%-glob=(.+)$")
		if glob_eq then
			table.insert(globs, glob_eq)
			i = i + 1
			-- --glob PATTERN
		elseif tok == "--glob" then
			if tokens[i + 1] then
				table.insert(globs, tokens[i + 1])
				i = i + 2
			else
				break
			end
			-- -gPATTERN
		elseif tok:match("^%-g.+") then
			table.insert(globs, tok:sub(3))
			i = i + 1
			-- -g PATTERN
		elseif tok == "-g" then
			if tokens[i + 1] then
				table.insert(globs, tokens[i + 1])
				i = i + 2
			else
				break
			end

			-- --type=TYPE
		elseif tok:match("^%-%-type=") then
			type_include = tok:match("^%-%-type=(.+)$")
			i = i + 1
			-- --type TYPE
		elseif tok == "--type" then
			if tokens[i + 1] then
				type_include = tokens[i + 1]
				i = i + 2
			else
				break
			end
			-- -tTYPE shorthand
		elseif tok:match("^%-t.+") then
			type_include = tok:sub(3)
			i = i + 1

			-- --type-not=TYPE
		elseif tok:match("^%-%-type%-not=") then
			local tnot = tok:match("^%-%-type%-not=(.+)$")
			table.insert(extra, "--type-not")
			table.insert(extra, tnot)
			i = i + 1
			-- --type-not TYPE
		elseif tok == "--type-not" then
			if tokens[i + 1] then
				table.insert(extra, "--type-not")
				table.insert(extra, tokens[i + 1])
				i = i + 2
			else
				break
			end
			-- -TTYPE shorthand
		elseif tok:match("^%-T.+") then
			table.insert(extra, "--type-not")
			table.insert(extra, tok:sub(3))
			i = i + 1
		else
			-- Ignore unknown tokens; you can push them to extra if you want to
			-- pass through arbitrary ripgrep flags:
			-- table.insert(extra, tok)
			i = i + 1
		end
	end

	local glob_opt = nil
	if #globs == 1 then
		glob_opt = globs[1]
	elseif #globs > 1 then
		glob_opt = globs
	end

	if #extra == 0 then
		extra = nil
	end

	return glob_opt, type_include, extra
end

local function live_grep_dir_with_args()
	local home = vim.fn.expand("~")

	vim.ui.input({
		prompt = "Directory to search: ",
		default = home .. "/",
		completion = "dir",
	}, function(dir)
		if not dir or dir == "" then
			return
		end
		dir = vim.fn.expand(dir)
		if vim.fn.isdirectory(dir) == 0 then
			vim.notify(("Not a directory: %s"):format(dir), vim.log.levels.WARN)
			return
		end

		vim.ui.input({
			prompt = "Args (-g/--glob, -t/--type, -T/--type-not). Example: -g *.lua -trust ",
			default = "",
		}, function(argline)
			local glob_opt, type_include, extra = parse_args(argline)

			builtin.live_grep({
				cwd = dir,
				glob_pattern = glob_opt, -- string or table or nil
				type_filter = type_include, -- string or nil
				additional_args = extra, -- table or nil
			})
		end)
	end)
end
map("n", "<leader>spg", live_grep_dir_with_args, { desc = "Search Path with Grep (can use rg --type | --glob)" })
-- live_grep_with_args END >>>

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

-- Conflicts with git hunks
-- map('n', '[h', function()
-- 	harpoon:list():prev { ui_nav_wrap = true }
-- end, { desc = 'Previous Harpoon File' })
--
-- map('n', ']h', function()
-- 	harpoon:list():next { ui_nav_wrap = true }
-- end, { desc = 'Next Harpoon File' })

map('n', '<leader>hc', function()
	harpoon:list():clear()
end, { desc = 'Clear Harpoon List' })

for i = 1, 9 do
	map('n', string.format('<leader>h%s', i), function()
		harpoon:list():select(i)
	end, { desc = string.format('Jump to Harpoon File %s', i) })
end

-- LuaSnip --
-- Using blink integration

-- Misc --

-- Creates a Telescope window containing all packages in vim.pack.get()
map('n', '<leader>pt', function()
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
-- Purpose: Allows for macro to vim.pack.del() or .update()
-- Future: Could modify to have a Lazy.nvim style updater/deleter
map('n', '<leader>pl', function()
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

	local ns = vim.api.nvim_create_namespace('')
	vim.api.nvim_set_hl(0, 'PluginHeader', { fg = '#ffb4fa', bold = true })
	vim.hl.range(buf, ns, 'PluginHeader', { 0, 0 }, { 0, -1 }, { regtype = 'v', inclusive = true }) -- is the up
end, { desc = 'List All Packages (buffer)' })
