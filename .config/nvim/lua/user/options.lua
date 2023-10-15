-- Allow backspace to go through the following
 vim.opt.backspace = 'indent,eol,start'

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.number = true
vim.opt.relativenumber = true

-- Complete the longest common match and allow tabbing the results to fully complete them
vim.opt.wildmode = 'longest:full,full'
vim.opt.completeopt = 'menuone,longest,preview'

vim.opt.title = true

-- Disable mouse support because unacceptable with WMs that do not have 'Focus Follow Mouse'
vim.opt.mouse = ''

-- Enable true color
vim.opt.termguicolors = true

-- Disable spell checks
vim.opt.spell = false

vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Enable listchars option below
vim.opt.list = true
vim.opt.listchars = { tab = '▶ ', trail = '-', extends = '>', precedes = '<', nbsp = '+' }
-- Remove ~ from the empty buffer
vim.opt.fillchars:append({ eob = ' ' })

-- New horizontal split to the bottom
vim.opt.splitbelow = true
-- New vertical split to the right
vim.opt.splitright = true

-- History of ":" commands and search patterns
vim.opt.history = 1000

-- Wait ttimeoutlen to complete a key code sequence
vim.opt.ttimeout = true
-- Milliseconds to wait
vim.opt.ttimeoutlen = 100

-- Enable soft-wrapping
vim.opt.wrap = true

-- Keep cursor away from border lines
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Ask for confirmation when closing with unsaved changes
vim.opt.confirm = true

-- Keep sign column
vim.opt.signcolumn = 'yes:2'

-- Persistent undo
vim.opt.undofile = true

-- Automatically save a backup file
vim.opt.backup = true
-- Do not save backup files in the current directory
vim.opt.backupdir:remove('.')

-- Do not insert the comma leader on new lines automatically
-- We put this in an autocmd, because the internal ftplugin of neovim overwrites the formatoptions on each BufEnter event
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  callback = function()
    vim.opt.formatoptions:remove('r')
    vim.opt.formatoptions:remove('o')
  end,
})
