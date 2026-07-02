return {
  "huggingface/llm.nvim",
  event = "InsertEnter",
  opts = {
    backend = "ollama",
    model = "qwen2.5-coder:1.5b",
    url = "http://192.168.0.150:11434", -- Your local Ollama endpoint
    api_token = "local-bypass", -- Crucial: Prevents a nil string concatenation error
    -- Timing and interactions
    debounce_ms = 300,
    accept_keymap = "<Tab>",
    dismiss_keymap = "<S-Tab>",
    -- See Step 3 for the FIM configuration that goes here
    -- FIM tokens remain exactly the same for Qwen 3.5
    fim = {
      enabled = true,
      prefix = "<|fim_prefix|>",
      middle = "<|fim_middle|>",
      suffix = "<|fim_suffix|>",
    },
    request_body = {
      options = {
        temperature = 0.1,
        top_p = 0.95,
      }
    }
  }
}
