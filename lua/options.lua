vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.signcolumn = 'yes'

vim.opt.wrap = false
-- set below to true if wrap is true
-- vim.opt.breakindent = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.opt.swapfile = false

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.smartindent = true

vim.opt.termguicolors = true

vim.opt.winborder = 'rounded'

vim.opt.scrolloff = 4

vim.opt.shell = '/bin/zsh'
vim.opt.shellcmdflag = '-ic'

vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)
