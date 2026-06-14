return {
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

      -- ===============================================
    -- Add mini.clue here
    -- ===============================================
    local miniclue = require('mini.clue')
    miniclue.setup({
      -- 1. You MUST define triggers to make the clue window pop up
      triggers = {
        -- Leader triggers
        { mode = 'n', keys = '<Leader>' },
        { mode = 'x', keys = '<Leader>' },

        -- Built-in Neovim triggers
        { mode = 'n', keys = '\\' }, -- Local Leader
        { mode = 'n', keys = 'g' },  -- g key
        { mode = 'x', keys = 'g' },
        { mode = 'n', keys = "'" },  -- Marks
        { mode = 'n', keys = '`' },
        { mode = 'x', keys = "'" },
        { mode = 'x', keys = '`' },
        { mode = 'n', keys = '"' },  -- Registers
        { mode = 'x', keys = '"' },
        { mode = 'i', keys = '<C-r>' },
        { mode = 'c', keys = '<C-r>' },
        { mode = 'n', keys = '<C-w>' }, -- Window commands
        { mode = 'n', keys = 'z' },     -- Folds
        { mode = 'x', keys = 'z' },
      },

      -- 2. Generate descriptions for built-in Neovim commands
      clues = {
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
      },
    })

    -- Your existing setups stay here
    require("mini.files").setup()
    
    -- (Your mini.clue setup is here)

    -- ===============================================
    -- GOLANG / LUA AUTO-COMPLETE SUGGESTIONS
    -- ===============================================
    -- 1. Configure how the popup menu looks and behaves
    vim.opt.completeopt = "menu,menuone,noselect"

    -- 2. Enable the completion module
    require("mini.completion").setup({
      -- Delay in milliseconds before the menu pops up
      delay = { completion = 100, info = 100, signature = 50 },
      
      -- Customize the popup window
      window = {
        info = { border = 'rounded' },
        signature = { border = 'rounded' },
      }
    })
    end
}
