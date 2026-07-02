return {
  "yetone/avante.nvim",
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  -- ⚠️ must add this setting! ! !
  build = vim.fn.has("win32") ~= 0
      and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    -- Set Gemini as your default provider
    provider = "gemini",
    
    -- Gemini Configuration
    providers = {
      gemini = {
        model = "gemini-2.5-flash-lite",
        api_key_name = "GEMINI_TOKEN", -- Reads directly from your shell
        timeout = 30000,
        temperature = 0,
        disable_tools = true,
      },
      gemma4 = {
        __inherited_from = "gemini",
        -- model = "gemma-4-26b-a4b-it", -- MoE, fast; or "gemma-4-31b-it" for the stronger dense model
        model = "gemma-4-31b-it", -- MoE, fast; or "gemma-4-31b-it" for the stronger dense model
        api_key_name = "GEMINI_TOKEN",
        timeout = 90000,
        temperature = 0,
      },
      -- Cloudflare Workers AI Configuration (OpenAI Compatible)
      cloudflare = {
          __inherited_from = "openai",
          api_key_name = "CLOUDFLARE_TOKEN",
          endpoint = "https://api.cloudflare.com/client/v4/accounts/394bc59ef44c708759ca2968ccd9be5c/ai/v1",
          model = "@cf/zai-org/glm-5.2",
      },
      mistral = {
        __inherited_from = "openai",
        endpoint = "https://api.mistral.ai/v1",
        model = "mistral-medium-latest", -- flagship general-purpose model
        api_key_name = "MISTRAL_API_KEY",
        extra_request_body = {
          max_tokens = 4096, -- see note below
        },
      },
    },
    -- add any opts here
    -- this file can contain specific instructions for your project
    instructions_file = "avante.md",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "nvim-mini/mini.pick", -- for file_selector provider mini.pick
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "ibhagwan/fzf-lua", -- for file_selector provider fzf
    "stevearc/dressing.nvim", -- for input provider dressing
    "folke/snacks.nvim", -- for input provider snacks
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
