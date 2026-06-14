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

vim.api.nvim_create_autocmd("BufWritePre", {
pattern = "*.go",
callback = function()
-- 1. Ask gopls to organize imports synchronously
local params = vim.lsp.util.make_range_params()
params.context = {only = {"source.organizeImports"}}

-- We use a synchronous request with a 1000ms timeout so the 
-- file doesn't save until the imports are ready.
local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
for cid, res in pairs(result or {}) do
  for _, r in pairs(res.result or {}) do
    if r.edit then
      local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
      vim.lsp.util.apply_workspace_edit(r.edit, enc)
    end
  end
end

-- 2. Format the code (also synchronously)
vim.lsp.buf.format({ async = false })
end
})

-- 3. Install mini.nvim and set up plugins
require("lazy").setup("plugins")
