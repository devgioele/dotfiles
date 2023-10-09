return {
  {
    "folke/tokyonight.nvim",
    lazy     = false, -- make sure we load this during startup
    priority = 1000,  -- make sure to load this before all the other start plugins
    opts     = {
      style = "night",
    },
    config   = function()
      -- load the colorscheme here
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
      'nvim-treesitter/nvim-treesitter-textobjects'
    },
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup {
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "html", "css", "go",
          "astro", "svelte", "tsx" },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
        },
        context_commentstring = {
          enable = true,
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['if'] = '@function.inner',
              ['af'] = '@function.outer',
              ['ia'] = '@parameter.inner',
              ['aa'] = '@parameter.outer',
              ['ic'] = '@class.inner',
              ['ac'] = '@class.outer',
            },
          }
        }
      }
    end
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
    opts = {}
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
      require('telescope').load_extension('fzf')
      require('telescope').load_extension('live_grep_args')
      require('telescope').load_extension('ui-select')

      -- Hightlight groups
      -- vim.cmd([[
      --   highlight link TelescopePromptTitle PMenuSel
      --   highlight link TelescopePreviewTitle PMenuSel
      --   highlight link TelescopePromptNormal NormalFloat
      --   highlight link TelescopePromptBorder FloatBorder
      --   highlight link TelescopeNormal CursorLine
      --   highlight link TelescopeBorder CursorLineBg
      -- ]])

      -- Keymaps
      vim.keymap.set('n', '<leader>f', [[<cmd>lua require('telescope.builtin').find_files()<CR>]])
      vim.keymap.set('n', '<leader>F',
        [[<cmd>lua require('telescope.builtin').find_files({ no_ignore = true, prompt_title = 'All Files' })<CR>]])
      vim.keymap.set('n', '<leader>b', [[<cmd>lua require('telescope.builtin').buffers()<CR>]])
      vim.keymap.set('n', '<leader>g', [[<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>]])
      vim.keymap.set('n', '<leader>h', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]])
      vim.keymap.set('n', '<leader>s', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]])
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

  -- The bridge between mason and lspconfig
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
    },
    opts = {
      automatic_installation = true
    }
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
    config = function()
      local luasnip = require('luasnip')
      local lspkind = require('lspkind')
      local cmp = require('cmp')
      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        formatting = {
          format = lspkind.cmp_format()
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
          ['<C-d>'] = cmp.mapping.scroll_docs(4),  -- Down
          -- C-b (back) C-f (forward) for snippet placeholder navigation.
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = {
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
          { name = 'npm',                    keyword_length = 4 }
        },
      }
    end
  },

  -- Configurations for the built-in LSP client
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'b0o/schemastore.nvim',
      'hrsh7th/nvim-cmp',
    },
    config = function()
      -- Add additional capabilities supported by nvim-cmp
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require('lspconfig')
      lspconfig.lua_ls.setup {
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
            client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
              Lua = {
                runtime = {
                  -- Tell the language server which version of Lua you're using
                  -- (most likely LuaJIT in the case of Neovim)
                  version = 'LuaJIT'
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                  }
                  -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                  -- library = vim.api.nvim_get_runtime_file("", true)
                }
              }
            })
            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
          end
          return true
        end
      }
      lspconfig.marksman.setup {
        capabilities = capabilities
      }
      lspconfig.volar.setup {
        capabilities = capabilities,
        -- Enable "Take Over Mode" to use volar not just for vue
        filetypes = { 'html', 'css', 'typescript', 'javascript', 'javascriptreact', 'javascript.jsx', 'typescriptreact',
          'typescript.tsx', 'astro', 'svelte' }
      }
      lspconfig.tailwindcss.setup {
        capabilities = capabilities
      }
      lspconfig.unocss.setup {
        capabilities = capabilities
      }
      lspconfig.jsonls.setup {
        capabilities = capabilities,
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      }
      lspconfig.yamlls.setup {
        capabilities = capabilities,
        settings = {
          yaml = {
            schemaStore = {
              -- You must disable built-in schemaStore support if you want to use
              -- this plugin and its advanced options like `ignore`.
              enable = false,
              -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
              url = "",
            },
            schemas = require('schemastore').yaml.schemas(),
          },
        },
      }
      lspconfig.arduino_language_server.setup {
        capabilities = capabilities
      }
      lspconfig.clangd.setup {
        capabilities = capabilities
      }
      lspconfig.cmake.setup {
        capabilities = capabilities
      }
      lspconfig.rust_analyzer.setup {
        capabilities = capabilities
      }
      lspconfig.svelte.setup {
        capabilities = capabilities
      }
      -- The Java language server of Eclipse
      lspconfig.jdtls.setup {
        capabilities = capabilities
      }
      -- Python
      lspconfig.jedi_language_server.setup {
        capabilities = capabilities
      }
      -- Go
      lspconfig.gopls.setup {
        capabilities = capabilities
      }

      -- Keymaps
      vim.keymap.set('n', '<Leader>d', '<cmd>lua vim.diagnostic.open_float()<CR>')
      vim.keymap.set('n', '<Leader>D', ':Telescope diagnostics<CR>')
      vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
      vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')
      vim.keymap.set('n', 'gd', ':Telescope lsp_definitions<CR>')
      vim.keymap.set('n', 'gi', ':Telescope lsp_implementations<CR>')
      vim.keymap.set('n', 'gt', ':Telescope lsp_type_definitions<CR>')
      vim.keymap.set('n', 'gr', ':Telescope lsp_references<CR>')
      vim.keymap.set('n', '<Leader>k', '<cmd>lua vim.lsp.buf.hover()<CR>')
      vim.keymap.set('n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
      vim.keymap.set('n', '<Leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
      vim.keymap.set('n', "<Leader>'", ':Telescope resume<CR>')
      vim.keymap.set('n', '<Leader>"', ':Telescope pickers<CR>')

      -- Diagnostic configuration
      vim.diagnostic.config({
        virtual_text = false,
        float = {
          source = true,
        }
      })

      -- Sign configuration
      vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticSignError' })
      vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticSignWarn' })
      vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo' })
      vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })
    end
  },

  -- Linting & Formatting
  {
    'mfussenegger/nvim-lint',
    config = function()
      -- Linting
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
      require("formatter").setup {
        logging = true,
        log_level = vim.log.levels.WARN,
        filetype = {
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
      }
      local formatting_enabled = true
      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function()
          if formatting_enabled then
            vim.cmd(':FormatWrite')
          end
        end
      })
      vim.api.nvim_create_user_command('InvFormat', function()
        formatting_enabled = not formatting_enabled
      end, {})
    end
  }
}
