-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Горячие клавиши для буфера обмена
vim.keymap.set("n", "<leader>cp", "<cmd>Telescope neoclip<cr>", { desc = "Clipboard History" })
vim.keymap.set("n", "<leader>cy", "\"+y", { desc = "Copy to System Clipboard" })
vim.keymap.set("v", "<leader>cy", "\"+y", { desc = "Copy to System Clipboard" })
vim.keymap.set("n", "<leader>cp", "\"+p", { desc = "Paste from System Clipboard" })
vim.keymap.set("n", "<leader>cP", "\"+P", { desc = "Paste from System Clipboard (before)" })

-- Интеграция с nvim-tree для avante (если используется)
vim.keymap.set("n", "<leader>a+", function()
  local ok, tree_ext = pcall(require, "avante.extensions.nvim_tree")
  if ok then
    tree_ext.add_file()
  end
end, { desc = "AI Select File in NvimTree" })

vim.keymap.set("n", "<leader>a-", function()
  local ok, tree_ext = pcall(require, "avante.extensions.nvim_tree")
  if ok then
    tree_ext.remove_file()
  end
end, { desc = "AI Deselect File in NvimTree" })
