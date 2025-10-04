-- Дополнительная конфигурация для avante.nvim
if true return {}

local M = {}

function M.setup()
  -- Настройка пользовательских промптов
  local function setup_custom_prompts()
    -- Создаем директорию для пользовательских промптов
    local prompt_dir = vim.fn.expand("~/.config/nvim/avante_prompts")
    if vim.fn.isdirectory(prompt_dir) == 0 then
      vim.fn.mkdir(prompt_dir, "p")
    end
  end

  -- Инициализация
  setup_custom_prompts()
end

return M 
