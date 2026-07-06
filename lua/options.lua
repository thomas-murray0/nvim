vim.opt.swapfile = false

vim.opt.updatetime = 500 -- ms for swap file to be written if nothing is happening. Also for CursorHold events. Default is 4000

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.cursorline = true

vim.opt.signcolumn = 'yes'

vim.opt.wrap = false
-- set below to true if wrap is true
-- vim.opt.breakindent = true

vim.opt.expandtab = true
-- vim.opt.tabstop = 2
-- vim.opt.softtabstop = 2
-- vim.opt.shiftwidth = 2

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.smartindent = true

vim.opt.termguicolors = true

vim.opt.winborder = 'rounded'

vim.opt.scrolloff = 5

vim.opt.shell = '/bin/zsh'
vim.opt.shellcmdflag = '-c' -- add 'i' for interactive shell, forget what this does but it is useful sometimes

vim.opt.spell = false
vim.opt.spelllang = { "en_us" }

vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)
