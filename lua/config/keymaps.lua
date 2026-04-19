-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Буфер обмена: cp/cP — вставка; cH — история (NeoClip), без пересечения с cp и с clangd <leader>ch
vim.keymap.set("n", "<leader>cH", "<cmd>Telescope neoclip<cr>", { desc = "Clipboard History (NeoClip)" })
vim.keymap.set("n", "<leader>cy", '"+y', { desc = "Copy to System Clipboard" })
vim.keymap.set("v", "<leader>cy", '"+y', { desc = "Copy to System Clipboard" })
vim.keymap.set("n", "<leader>cp", '"+p', { desc = "Paste from System Clipboard" })
vim.keymap.set("n", "<leader>cP", '"+P', { desc = "Paste from System Clipboard (before)" })
