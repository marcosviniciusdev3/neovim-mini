-- 1. Set leader keys before loading anything else
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 2. Bootstrap lazy.nvim (the package manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 3. Install mini.nvim and set up plugins
require("lazy").setup({
  {
    "echasnovski/mini.nvim",
    version = false, -- Use the main branch for the latest features
    config = function()
      -- 4. Enable the mini modules you want to use
      -- Every module MUST be explicitly set up. 

      -- mini.basics: Sets common sensible defaults and keymaps
      require("mini.basics").setup()

      -- mini.statusline: A clean and minimal status bar at the bottom
      require("mini.statusline").setup()

      -- mini.files: A file explorer that lets you edit your file system like a text buffer
      require("mini.files").setup()
      -- Map '-' to open the file explorer
      vim.keymap.set("n", "-", function() require("mini.files").open() end, { desc = "Open mini.files" })

      -- mini.surround: Add, delete, or replace surrounding characters (quotes, brackets)
      require("mini.surround").setup()

      -- mini.pairs: Automatically close brackets and quotes
      require("mini.pairs").setup()

      -- mini.icons: Adds file icons (requires a Nerd Font installed on your terminal)
      require("mini.icons").setup()
      
      -- mini.pick: A fast fuzzy finder for files, buffers, and text
      require("mini.pick").setup()
      vim.keymap.set("n", "<leader>ff", function() require("mini.pick").builtin.files() end, { desc = "Find Files" })
      vim.keymap.set("n", "<leader>fg", function() require("mini.pick").builtin.grep_live() end, { desc = "Live Grep" })

      -- mini.colors: Set a built-in colorscheme 
      require("mini.hues").setup({ background = "#1e1e2e", foreground = "#cdd6f4" })
    end
  },
  {
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
})
