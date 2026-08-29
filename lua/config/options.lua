-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.lazyvim_check_order = false

-- Review-first workflow: formatting is always an explicit <leader>cf action.
vim.g.autoformat = false

-- Keep the unnamed register local to Nvim. Explicit context-yank actions use
-- OSC 52 to reach the clipboard of the Herdr client, including over SSH.
vim.opt.clipboard = ""
vim.g.clipboard = "osc52"
