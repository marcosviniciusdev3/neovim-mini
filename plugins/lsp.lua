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
        "lua_ls", -- Lua
        -- Add your languages here, e.g.:
        -- "ts_ls",      -- TypeScript/JavaScript
        -- "pyright",    -- Python
        -- "rust_analyzer" -- Rust
      },
    })

    -- 3. Automatically wire up every server installed via Mason
    local lspconfig = require("lspconfig")
    require("mason-lspconfig").setup_handlers({
      function(server_name)
        lspconfig[server_name].setup({})
      end,
    })
    
    -- 4. Setup Keymaps (See Step 2 below)
  end
}
