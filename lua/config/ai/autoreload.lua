local M = {}

function M.setup()
  vim.opt.autoread = true

  local group = vim.api.nvim_create_augroup("config_ai_autoreload", { clear = true })
  vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "TermClose", "TermLeave" }, {
    group = group,
    callback = function()
      if vim.fn.mode() ~= "c" then
        vim.cmd.checktime()
      end
    end,
  })
end

return M
