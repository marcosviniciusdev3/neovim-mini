return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
  },
  opts = {
    ensure_installed = {
      "lua_ls",  -- Lua
      "gopls",   -- Go
      "pyright", -- Python
      -- "ts_ls",
      -- "eslint",
    },
    -- automatic_enable = true is the default — it calls vim.lsp.enable()
    -- for every installed server, so nothing extra needed below
  },
  config = function(_, opts)
    require("mason-lspconfig").setup(opts)

    -- Applied to every server before its own vim.lsp.config() override
    vim.lsp.config('*', {
      root_markers = { '.git' },
    })

    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
        },
      },
    })

    vim.lsp.config('gopls', {
      settings = {
        gopls = { gofumpt = true, staticcheck = true }
      },
    })


    vim.api.nvim_create_autocmd('LspAttach', {
      desc = 'LSP actions',
      callback = function(event)
        local kopts = { buffer = event.buf }

        vim.keymap.set('n', 'K', vim.lsp.buf.hover, kopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, kopts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, kopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, kopts)
        vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, kopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, kopts)
        vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, kopts)
        vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, kopts)
        vim.keymap.set({ 'n', 'x' }, '<F3>', function()
          vim.lsp.buf.format({ async = true })
        end, kopts)
        vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, kopts)
      end,
    })
  end,
}
