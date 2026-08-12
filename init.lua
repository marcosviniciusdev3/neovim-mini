-- 1. Set leader keys before loading anything else
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set the number of spaces that a <Tab> in the file counts for
vim.opt.tabstop = 2

-- Set the number of spaces inserted for each indentation level
vim.opt.shiftwidth = 2

vim.opt.expandtab = true

-- Enable relative line numbers
vim.opt.relativenumber = true

-- Keep the current line number highlighted (Hybrid mode)
vim.opt.number = true

-- Sync Neovim's clipboard with your system clipboard
vim.opt.clipboard = "unnamedplus"

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

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'svelte', 'python', 'javascript', 'typescript', 'typescriptreact', 'rust', 'go', 'c', 'c++' },
    callback = function()
        vim.treesitter.start()
    end,
})

-- Map Space + q to delete the current buffer
vim.keymap.set('n', '<leader>q', ':bd<CR>', { desc = 'Delete current buffer' })

-- Vim window key bindings
-- Navigate between windows in Normal mode
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = "Move to left split" })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = "Move to below split" })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = "Move to above split" })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = "Move to right split" })

-- Easily hit ESC to go back to Normal-mode in the terminal
vim.keymap.set('t', '<Esc><Esc>', [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- Navigate directly from the terminal without explicitly escaping first
vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], { desc = "Move to left split" })
vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], { desc = "Move to below split" })
vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], { desc = "Move to above split" })
vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], { desc = "Move to right split" })

--- Diagnostics
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {
  desc = "Show line diagnostics",
})
vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1 })
end)
vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1 })
end)

--- AutoCommand at Startup
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        -- set color scheme to mini.colors 
        vim.cmd("colorscheme wildcharm")
    end,
})

-- 3. Install mini.nvim and set up plugins
require("lazy").setup("plugins")
