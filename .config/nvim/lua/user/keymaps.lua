local uv = vim.loop

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Move by terminal rows, not lines, unless a vertical count is provided
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true})
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true})

-- Reselect visual selection after indenting
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Maintain cursor position when yanking a visual selection
-- Set a mark, yank, move back to the mark
vim.keymap.set('v', 'y', 'myy`y')
vim.keymap.set('v', 'y', 'myY`y')

-- Paste replace visual selection without copying it
-- The register '_' is a black-hole register
vim.keymap.set('v', 'p', '"_dP')

-- Shortcut to insert trailing ; or , from insert mode
vim.keymap.set('i', ';;', '<Esc>A;')
vim.keymap.set('i', ',,', '<Esc>A,')

-- Quickly clear search highlighting
vim.keymap.set('n', '<Leader>/', ':nohlsearch<CR>')

-- Open the current file in the default program
vim.keymap.set('n', '<Leader>xd', ':!open %<CR><CR>')
-- Open the current file in Visual Studio Code
vim.keymap.set('n', '<Leader>xc', string.format(':!code %s %%<CR><CR>', uv.cwd()))

-- Move lines
vim.keymap.set('i', '<A-j>', '<Esc>:move .+1<CR>==gi')
vim.keymap.set('i', '<A-k>', '<Esc>:move .-2<CR>==gi')
vim.keymap.set('n', '<A-j>', ':move .+1<CR>==')
vim.keymap.set('n', '<A-k>', ':move .-2<CR>==')
vim.keymap.set('v', '<A-j>', ":move '>+1<CR>gv=gv")
vim.keymap.set('v', '<A-k>', ":move '<-2<CR>gv=gv")

-- Allow gf to open non-existent files
-- vim.keymap.set('n', 'gf', ':edit <cfile><CR>')
