return {
  "neovim/nvim-lspconfig",
  dependencies = {
    -- Mason handles the downloads
    "williamboman/mason.nvim",
    -- Bridges Mason with lspconfig
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    -- 1. Initialize Mason
    require("mason").setup()

    -- 2. Initialize the bridge and list servers you want automatically installed
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",       -- Lua
        -- "ts_ls",        -- TypeScript/JavaScript
        "eslint",        -- TypeScript/JavaScript
        "gopls",        -- Go
      },
    })
    -- 3. Configure/enable the LSP servers via the new Neovim 0.11+ API
    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    })
    
    vim.lsp.enable({ "lua_ls", "eslint", "gopls" })
    
    vim.api.nvim_create_autocmd('LspAttach', {
      desc = 'LSP actions',
      callback = function(event)
        local opts = {buffer = event.buf}

        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
      end,
    })
  end
}
