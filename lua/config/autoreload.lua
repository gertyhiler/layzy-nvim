local M = {}

function M.setup()
  vim.opt.autoread = true

  vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "TermClose", "TermLeave" }, {
    group = vim.api.nvim_create_augroup("review_autoreload", { clear = true }),
    callback = function()
      if vim.fn.mode() ~= "c" then
        vim.cmd.checktime()
      end
    end,
  })
end

return M
