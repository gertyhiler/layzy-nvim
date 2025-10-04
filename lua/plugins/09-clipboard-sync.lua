return {
  -- Дополнительные настройки буфера обмена
  {
    "LazyVim/LazyVim",
    opts = {
      -- Включаем синхронизацию с системным буфером обмена
      clipboard = {
        -- Автоматически синхронизировать с системным буфером
        sync_with_system = true,
        -- Использовать системный буфер по умолчанию
        default_register = '+',
      },
    },
  },

  -- Настройки для лучшей работы с буфером обмена
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      -- Устанавливаем опции буфера обмена
      vim.opt.clipboard = "unnamedplus"
      
      -- Автоматически синхронизировать с системным буфером
      vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
          vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
        end,
      })
    end,
  },
} 