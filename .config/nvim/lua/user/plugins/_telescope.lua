local actions = require('telescope.actions')
local previewers = require('telescope.previewers')
local lga_actions = require('telescope-live-grep-args.actions')

vim.cmd([[
  highlight link TelescopePromptTitle PMenuSel
  highlight link TelescopePreviewTitle PMenuSel
  highlight link TelescopePromptNormal NormalFloat
  highlight link TelescopePromptBorder FloatBorder
  highlight link TelescopeNormal CursorLine
  highlight link TelescopeBorder CursorLineBg
]])

require('telescope').setup({
  defaults = {
    path_display = {
      truncate = 1
    },
    layout_config = {
      prompt_position = 'top',
    },
    sorting_strategy = 'ascending',
    mappings = {
      i = {
        ['<ESC>'] = actions.close,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
      },
    },
    file_ignore_patterns = { '.git/' },
    cache_picker = {
      num_pickers = 5
    }
  },
  pickers = {
    find_files = {
      hidden = true,
    },
    buffers = {
      previewer = false,
      layout_config = {
        width = 80,
      },
    },
    oldfiles = {
      prompt_title = 'History',
    },
    lsp_references = {
      -- preview = require('telescope.config').values.file_previewer,
      show_line = false
    },
    diagnostics = {
      show_line = false,
      -- open_float = true
    },
  },
  extensions = {
    live_grep_args = {
      mappings = {
        i = {
          ["<A-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
        },
      },
    },
  },
})

require('telescope').load_extension('fzf')
require('telescope').load_extension('live_grep_args')

vim.keymap.set('n', '<leader>f', [[<cmd>lua require('telescope.builtin').find_files()<CR>]])
vim.keymap.set('n', '<leader>F', [[<cmd>lua require('telescope.builtin').find_files({ no_ignore = true, prompt_title = 'All Files' })<CR>]])
vim.keymap.set('n', '<leader>b', [[<cmd>lua require('telescope.builtin').buffers()<CR>]])
vim.keymap.set('n', '<leader>g', [[<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>]])
vim.keymap.set('n', '<leader>h', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]])
vim.keymap.set('n', '<leader>s', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]])
