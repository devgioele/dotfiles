-- TODO:
-- - Way of transforming a list of equal numbers to a list of ascending numbers
-- - Add a query for treesitter so that `dcss` deletes a css class. There might be a space before or after the css class that must be removed. For both left and right, there is a quote or a space. If there is a space, remove it. If there is space both left and right, remove only one of the two. https://github.com/nvim-treesitter/nvim-treesitter#adding-queries
-- - Add folke/trouble.nvim and make the workspace diagnostics work with eslint and typescript https://github.com/folke/trouble.nvim
-- - Tell LSP servers that a file is created, deleted or moved, so that I do not have to run `LspStart` or `LspRestart` each time. A.k.a. code refactoring
-- - Workspace-wide diagnostics. Look into the plugin 'trouble'
-- - Master jumplists
-- - Plugin to interact with the PostgreSQL 'psql'?


require('user/options')
require('user/keymaps')

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  install = {
    missing = true,
    -- Try to load one of these colorschemes when starting an installation during startup
    colorscheme = { "tokyonight", "habamax" },
  },
  checker = {
    -- Automatically check for plugin updates
    enabled = true,
    concurrency = nil,
    notify = false,
    frequency = 3600,
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
})

vim.keymap.set('n', '<leader>L', [[<cmd>Lazy<CR>]])

-- [[ Configure Treesitter ]]
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { "vim", "vimdoc", "bash", "c", "lua", "vim", "vimdoc", "query", "javascript", "typescript",
      "html", "css", "go",
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
    indent = { enable = true },
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
end, 0)

-- [[ Configure LSP ]]
local on_attach = function(client, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<Leader>d', vim.diagnostic.open_float)
  nmap('<Leader>D', require('telescope.builtin').diagnostics)
  nmap('[d', vim.diagnostic.goto_prev)
  nmap(']d', vim.diagnostic.goto_next)
  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('gt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('<Leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<Leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  nmap('<Leader>k', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<Leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<Leader>a', vim.lsp.buf.code_action, 'Code [A]ction')
  nmap("<Leader>'", require('telescope.builtin').resume, 'Resume telescope')
  nmap('<Leader>"', require('telescope.builtin').pickers, 'Telescope pickers')
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'FormatLsp', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

require('mason').setup()
require('mason-lspconfig').setup()

local lspconfig_util = require('lspconfig.util')
-- See the defaults at the nvim-lspconfig repo: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local servers = {
  lua_ls = {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false }
      }
    }
  },
  marksman = {},
  volar = {
    -- Enable "Take Over Mode" to use volar not just for vue
    filetypes = { 'html', 'css', 'typescript', 'javascript', 'javascriptreact', 'javascript.jsx',
      'typescriptreact',
      'typescript.tsx', 'svelte' }
  },
  astro = {},
  tailwindcss = {
    root_dir = lspconfig_util.root_pattern('tailwind.config.js', 'tailwind.config.cjs', 'tailwind.config.mjs',
      'tailwind.config.ts', 'postcss.config.js', 'postcss.config.cjs', 'postcss.config.mjs', 'postcss.config.ts')
  },
  unocss = {
    filetypes = { "html", "javascriptreact", "rescript", "typescriptreact", "vue", "svelte", "astro" },
    root_dir = lspconfig_util.root_pattern('unocss.config.js', 'unocss.config.ts', 'uno.config.js', 'uno.config.ts')
  },
  jsonls = {
    settings = {
      json = {
        schemas = require('schemastore').json.schemas(),
        validate = { enable = true },
      },
    },
  },
  yamlls = {
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
  },
  arduino_language_server = {},
  clangd = {},
  cmake = {},
  rust_analyzer = {},
  svelte = {},
  -- The Java language server of Eclipse
  jdtls = {},
  -- Python
  jedi_language_server = {},
  -- Go
  gopls = {},
  bashls = {}
}

-- Setup neovim lua configuration
require('neodev').setup()

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup {
  automatic_installation = true,
  ensure_installed = vim.tbl_keys(servers)
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = (servers[server_name] or {}).settings,
      filetypes = (servers[server_name] or {}).filetypes,
      root_dir = (servers[server_name] or {}).root_dir,
    }
  end,
}

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

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', '<Leader>d', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '<Leader>D', ':Telescope diagnostics<CR>', opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', 'gd', ':Telescope lsp_definitions<CR>', opts)
    vim.keymap.set('n', 'gi', ':Telescope lsp_implementations<CR>', opts)
    vim.keymap.set('n', 'gt', ':Telescope lsp_type_definitions<CR>', opts)
    vim.keymap.set('n', 'gr', ':Telescope lsp_references<CR>', opts)
    vim.keymap.set('n', '<Leader>k', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<Leader>a', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', "<Leader>'", ':Telescope resume<CR>', opts)
    vim.keymap.set('n', '<Leader>"', ':Telescope pickers<CR>', opts)
  end
})

-- [[ Configure nvim-cmp ]]
local cmp = require('cmp')
local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}
local lspkind = require('lspkind')

cmp.setup {
  preselect = cmp.PreselectMode.None,
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
      select = false,
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
    { name = 'nvim_lsp',               trigger_characters = { '-' } },
    { name = 'nvim_lsp_signature_help' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'npm',                    keyword_length = 4 }
  },
}
