vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true }) -- space should only be <leader>
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

require 'options'

require 'plugins'

require 'keymaps'

require 'autocommands'

require 'lsp'
