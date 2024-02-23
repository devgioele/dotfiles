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

  -- Repo: https://github.com/dstein64/vim-startuptime
  {
    "dstein64/vim-startuptime",
    version = "^4.0.0",
    -- lazy-load on a command
    cmd     = "StartupTime",
    -- init is called during startup. Configuration for vim plugins typically should be set in an init function
    init    = function()
      vim.g.startuptime_tries = 10
    end,
  },

  -- Commentary support
  -- Repo: https://github.com/tpope/vim-commentary
  {
    "tpope/vim-commentary",
  },

  -- Surroundings utils
  -- Repo: https://github.com/tpope/vim-surround
  "tpope/vim-surround",

  -- UNIX helpers
  -- Repo: https://github.com/tpope/vim-eunuch
  "tpope/vim-eunuch",

  -- Create missing parent directories when saving files
  -- Repo: https://github.com/jessarcher/vim-heritage
  "jessarcher/vim-heritage",

  -- Indent autodetection with .editorconfig support
  -- Repo: https://github.com/tpope/vim-sleuth
  "tpope/vim-sleuth",

  -- Shortcuts for word variants
  -- Repo: https://github.com/tpope/vim-abolish
  "tpope/vim-abolish",

  -- Key bindings suggestions
  -- Repo: https://github.com/folke/which-key.nvim
  {
    "folke/which-key.nvim",
    version = "^1.0.0",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {}
  },

  -- Git commands
  -- Repo: https://github.com/tpope/vim-fugitive
  "tpope/vim-fugitive",

  -- Repo: https://github.com/lewis6991/gitsigns.nvim
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
  -- Repo: https://github.com/nvim-treesitter/nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ":TSUpdate",
  },


  -- Automatically add closing brackets, quotes, etc.
  -- Repo: https://github.com/windwp/nvim-autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {}
  },

  -- Autoclose and autorename html tags
  -- Repo: https://github.com/windwp/nvim-ts-autotag
  {
    "windwp/nvim-ts-autotag",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      enable_close_on_slash = false
    }
  },

  -- Fuzzy finder over lists
  -- Repo: https://github.com/nvim-telescope/telescope.nvim
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
              ["<C-h>"] = actions.which_key,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            },
          },
          file_ignore_patterns = { '.git/' },
          cache_picker = {
            num_pickers = 10
          }
        },
        pickers = {
          find_files = {
            hidden = true,
          },
          buffers = {
            -- previewer = false,
            -- layout_config = {
            --   width = 80,
            -- },
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
            vimgrep_arguments = {
              "rg",
              "--color=never",
              "--no-heading",
              "--with-filename",
              "--line-number",
              "--column",
              "--smart-case",
              "--hidden",
            },
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
      local nmap = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { desc = desc })
      end
      nmap('<leader>f', require('telescope.builtin').find_files, 'Find workspace files that are not ignored')
      nmap('<leader>F',
        function() require('telescope.builtin').find_files({ no_ignore = true, prompt_title = 'Find All Files' }) end,
        'Find any workspace file')
      nmap('<leader>b', require('telescope.builtin').buffers, 'List open buffers')
      nmap('<leader>g', require('telescope').extensions.live_grep_args.live_grep_args,
        'Search with [g]rep files that are not ignored')
      nmap('<leader>G', function()
        require('telescope').extensions.live_grep_args.live_grep_args({
          prompt_title = "Live Grep (Args) All Files",
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--no-ignore"
          }
        })
      end, 'Search with [g]rep any workspace file')
      nmap('<leader>H', require('telescope.builtin').oldfiles, 'Open the [H]istory of buffers')
      nmap("<leader>'", require('telescope.builtin').resume, 'Resume telescope session')
      nmap('<leader>"', require('telescope.builtin').pickers, 'List telescope sessions')
    end
  },

  -- Color picker and highlighter
  -- Repo: https://github.com/uga-rosa/ccc.nvim
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
  -- Repo: https://github.com/williamboman/mason.nvim
  {
    'williamboman/mason.nvim',
    version = "^1.0.0",
    opts = {}
  },

  -- Completion plugin
  -- NeoVIM does only support on-demand completion. With this plugin we add autocompletion
  -- Repo: https://github.com/hrsh7th/nvim-cmp
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
      {
        'David-Kunz/cmp-npm',
        dependencies = { 'nvim-lua/plenary.nvim' },
        ft = "json",
        opts = {}
      },
      -- Snippets plugin
      -- Repo: https://github.com/L3MON4D3/LuaSnip
      {
        'L3MON4D3/LuaSnip',
        version = "^2.0.0",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
          require('luasnip').setup {}
          require("luasnip.loaders.from_vscode").lazy_load()
        end
      },
    },
  },

  -- Configurations for the built-in LSP client
  -- Repo: https://github.com/neovim/nvim-lspconfig
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

  -- Repo: https://github.com/mfussenegger/nvim-lint
  {
    'mfussenegger/nvim-lint',
    config = function()
      local lint = require('lint')
      -- TODO: Use eslint_d only if the project contains an eslint config
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

  -- Repo: https://github.com/stevearc/conform.nvim
  {
    'stevearc/conform.nvim',
    config = function()
      require('conform').setup({
        formatters_by_ft = {
          -- Run eslint_d if available and prettierd if available
          typescript = {
            { 'eslint_d', 'prettierd' }
          },
          javascript = {
            { 'eslint_d', 'prettierd' }
          },
          javascriptreact = {
            { 'eslint_d', 'prettierd' }
          },
          ['javascript.jsx'] = {
            { 'eslint_d', 'prettierd' }
          },
          typescriptreact = {
            { 'eslint_d', 'prettierd' }
          },
          ['typescript.tsx'] = {
            { 'eslint_d', 'prettierd' }
          }
        },
        format_on_save = function(bufnr)
          -- Disable with a global or buffer-local variable
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          return { timeout_ms = 500, lsp_fallback = true }
        end,
        formatters = {
          eslint_d = {
            -- The cwd is where any of the given files are found, starting from the one closest to the open file
            -- ESLint does also support adding the field 'eslintConfig' to the file 'package.json',
            -- but we ignore that
            cwd = require("conform.util").root_file({
              ".eslintrc.js",
              ".eslintrc.cjs",
              ".eslintrc.yaml",
              ".eslintrc.yml",
              ".eslintrc.json",
              "eslint.config.js"
            }),
            -- Do not run the formatter if the cwd is not found
            require_cwd = true
          },
          prettierd = {
            -- Prettier does also support adding the field 'prettier' to the file 'package.json',
            -- but we ignore that
            cwd = require("conform.util").root_file({
              ".prettierrc",
              ".prettierrc.json",
              ".prettierrc.yaml",
              ".prettierrc.yml",
              ".prettierrc.json5",
              ".prettierrc.js",
              "prettier.config.js",
              ".prettierrc.mjs",
              "prettier.config.mjs",
              ".prettierrc.cjs",
              "prettier.config.cjs",
              ".prettierrc.toml",
            }),
            require_cwd = true
          }
        }
      })
      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          -- FormatDisable! will disable formatting just for this buffer
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, {
        desc = "Disable autoformat-on-save",
        bang = true,
      })
      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = "Re-enable autoformat-on-save",
      })
    end
  },
}
