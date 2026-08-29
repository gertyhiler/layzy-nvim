-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local context = require("config.context")

vim.keymap.set("x", "<leader>y", context.copy_selection, { desc = "Yank Selection to Host Clipboard" })
vim.keymap.set("n", "<leader>yf", context.copy_file, { desc = "Yank File Path to Host Clipboard" })
vim.keymap.set({ "n", "x" }, "<leader>yr", context.copy_reference, { desc = "Yank File Reference" })
vim.keymap.set({ "n", "x" }, "<leader>yc", context.copy_context, { desc = "Yank Code Context" })

vim.keymap.set("n", "<leader>td", function()
  local commentstring = vim.bo.commentstring
  if commentstring == "" or not commentstring:find("%%s") then
    vim.notify("No comment string for this filetype", vim.log.levels.WARN, { title = "TODO" })
    return
  end

  local prefix, suffix = commentstring:match("^(.-)%%s(.*)$")
  local line = vim.api.nvim_get_current_line()
  local indent = line:match("^%s*") or ""
  local todo = indent .. prefix .. "TODO: " .. suffix
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, row, row, false, { todo })
  vim.api.nvim_win_set_cursor(0, { row + 1, #indent + #prefix + #"TODO: " })
  vim.cmd.startinsert({ bang = suffix == "" })
end, { desc = "Add TODO Comment Below" })
