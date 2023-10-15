-- TODO:
-- - Way of transforming a list of equal numbers to a list of ascending numbers
-- - Add a query for treesitter so that `dcss` deletes a css class. There might be a space before or after the css class that must be removed. For both left and right, there is a quote or a space. If there is a space, remove it. If there is space both left and right, remove only one of the two. https://github.com/nvim-treesitter/nvim-treesitter#adding-queries
-- - Add folke/trouble.nvim and make the workspace diagnostics work with eslint and typescript https://github.com/folke/trouble.nvim

return {
  {
    "folke/tokyonight.nvim",
    lazy     = false, -- make sure we load this during startup
    priority = 1000,  -- make sure to load this before all the other start plugins
    config   = function()
      require('tokyonight').setup {
        style  = "night",
        styles = {
          comments = { italic = false },
          keywords = { italic = false },
          functions = { italic = false },
          variables = { italic = false },
        },
      }
      vim.cmd([[colorscheme tokyonight-night]])
    end,
  },

  {
    "dstein64/vim-startuptime",
    -- lazy-load on a command
    cmd  = "StartupTime",
    -- init is called during startup. Configuration for vim plugins typically should be set in an init function
    init = function()
      vim.g.startuptime_tries = 10
    end,
  },

  -- Commentary support
  "tpope/vim-commentary",

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
  },

  -- Surroundings utils
  "tpope/vim-surround",

  -- UNIX helpers
  "tpope/vim-eunuch",

  -- Create missing parent directories when saving files
  "jessarcher/vim-heritage",

  -- Indent autodetection with .editorconfig support
  "tpope/vim-sleuth",

  -- Shortcuts for word variants
  "tpope/vim-abolish",

  -- Key bindings suggestions
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {}
  },

  -- Git commands
  "tpope/vim-fugitive",

  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add          = { text = '󱋱' },
        change       = { text = '󱋱' },
        delete       = { text = '󱇇' },
        topdelete    = { text = '󱇅' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']h', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, { expr = true })

        map('n', '[h', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, { expr = true })

        -- Actions
        map('n', '<leader>hs', gs.stage_hunk)
        map('n', '<leader>hu', gs.undo_stage_hunk)
        map('n', '<leader>hr', gs.reset_hunk)
        map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
        map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
        map('n', '<leader>hS', gs.stage_buffer)
        map('n', '<leader>hR', gs.reset_buffer)
        map('n', '<leader>hp', gs.preview_hunk)
        map('n', '<leader>hb', function() gs.blame_line { full = true } end)
        map('n', '<leader>tb', gs.toggle_current_line_blame)
        map('n', '<leader>hd', gs.diffthis)
        map('n', '<leader>hD', function() gs.diffthis('~') end)
        map('n', '<leader>td', gs.toggle_deleted)

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end
    }
  },

  -- Treesitter configurations and abstraction layer
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ":TSUpdate",
  },


  -- Automatically add closing brackets, quotes, etc.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {}
  },

  -- Autoclose and autorename html tags
  {
    "windwp/nvim-ts-autotag",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      autotag = {
        enable_close_on_slash = false
      }
    }
  },

  -- Fuzzy finder over lists
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        version = "^1.0.0",
      },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build =
        'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
      },
      {
        'nvim-telescope/telescope-ui-select.nvim'
      }
    },
    config = function(plugin, opts)
      local actions = require('telescope.actions')
      local lga_actions = require('telescope-live-grep-args.actions')
      require('telescope').setup {
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
            },
          },
          file_ignore_patterns = { '.git/' },
          cache_picker = {
            num_pickers = 8
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
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          live_grep_args = {
            mappings = {
              i = {
                ["<A-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              },
            },
          },
          ["ui-select"] = {
            -- TODO: Adjust ordering of code actions
          }
        },
      }
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'live_grep_args')
      pcall(require('telescope').load_extension, 'ui-select')

      -- Keymaps
      vim.keymap.set('n', '<leader>f', require('telescope.builtin').find_files)
      vim.keymap.set('n', '<leader>F',
        function() require('telescope.builtin').find_files({ no_ignore = true, prompt_title = 'All Files' }) end)
      vim.keymap.set('n', '<leader>b', require('telescope.builtin').buffers)
      vim.keymap.set('n', '<leader>g', require('telescope').extensions.live_grep_args.live_grep_args)
      vim.keymap.set('n', '<leader>h', require('telescope.builtin').oldfiles)
      vim.keymap.set('n', '<leader>s', require('telescope.builtin').lsp_document_symbols)
    end
  },

  -- Color picker and highlighter
  {
    'uga-rosa/ccc.nvim',
    event = "VeryLazy",
    opts = {
      highlighter = {
        auto_enable = true,
        lsp = true
      }
    }
  },

  -- The package manager mason
  {
    'williamboman/mason.nvim',
    opts = {}
  },

  -- Snippets plugin
  {
    'L3MON4D3/LuaSnip',
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require('luasnip').setup {}
      require("luasnip.loaders.from_vscode").lazy_load()
    end
  },

  -- nvim-cmp completion source for npm packages
  {
    'David-Kunz/cmp-npm',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ft = "json",
    opts = {}
  },

  -- Completion plugin
  -- NeoVIM does only support on-demand completion. With this plugin we add autocompletion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Completion source for LSP
      'hrsh7th/cmp-nvim-lsp',
      -- Completion source for snippets
      'saadparwaiz1/cmp_luasnip',
      -- Completion source for paths
      'hrsh7th/cmp-path',
      -- Completion source for buffer words
      -- 'hrsh7th/cmp-buffer',
      -- Completion source for displaying functions signatures with the current parameter emphasized
      'hrsh7th/cmp-nvim-lsp-signature-help',
      -- Pictograms for LSP completions items
      'onsails/lspkind-nvim',
      -- Completion source for npm packages
      'David-Kunz/cmp-npm',
      -- Snippets plugin
      'L3MON4D3/LuaSnip'
    },
  },

  -- Configurations for the built-in LSP client
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'b0o/schemastore.nvim',
      'hrsh7th/nvim-cmp',
      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
    },
  },

  {
    'mfussenegger/nvim-lint',
    config = function()
      local lint = require('lint')
      lint.linters_by_ft = {
        html = {
          'eslint_d'
        },
        css = {
          'eslint_d'
        },
        typescript = {
          'eslint_d'
        },
        javascript = {
          'eslint_d'
        },
        javascriptreact = {
          'eslint_d'
        },
        ['javascript.jsx'] = {
          'eslint_d'
        },
        typescriptreact = {
          'eslint_d'
        },
        ['typescript.tsx'] = {
          'eslint_d'
        }
      }
      vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end
  },

  {
    'mhartington/formatter.nvim',
    config = function()
      local util = require("formatter.util")
      local prettier = function()
        return {
          exe = "prettierd",
          args = { util.escape_path(util.get_current_buffer_file_path()) },
          stdin = true,
        }
      end
      -- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
      local filetype = {
        html = {
          prettier
        },
        css = {
          prettier
        },
        typescript = {
          prettier
        },
        javascript = {
          prettier
        },
        javascriptreact = {
          prettier
        },
        ['javascript.jsx'] = {
          prettier
        },
        typescriptreact = {
          prettier
        },
        ['typescript.tsx'] = {
          prettier
        },
        ["*"] = {
          require("formatter.filetypes.any").remove_trailing_whitespace
        }
      }
      require("formatter").setup {
        logging = true,
        log_level = vim.log.levels.WARN,
        filetype = filetype
      }
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)

          local formatting_enabled = true
          local format = function(opts)
            if filetype[vim.bo.filetype] ~= nil then
              vim.cmd(':FormatWrite')
            elseif client.server_capabilities.documentFormattingProvider then
              vim.lsp.buf.format({ async = opts.async })
            end
          end
          vim.api.nvim_create_autocmd("BufWritePost", {
            callback = function()
              if formatting_enabled then
                format { async = false }
              end
            end
          })
          vim.api.nvim_create_user_command('InvFormat', function()
            formatting_enabled = not formatting_enabled
          end, {})

          local nmap = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = ev.buf, desc = desc })
          end
          nmap('<leader>e', function()
            format { async = true }
          end, 'Format docum[e]nt')
        end
      })
    end
  }
}
