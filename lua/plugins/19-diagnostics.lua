return {
  -- Красивые inline диагностики с padding и скруглениями
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    priority = 1000,
    config = function()
      -- Отключаем стандартный virtual_text
      vim.diagnostic.config({ virtual_text = false })

      require("tiny-inline-diagnostic").setup({
        -- Стиль отображения
        preset = "modern", -- "modern", "classic", "minimal", "ghost", "simple", "nonerdfont"

        -- Настройки
        options = {
          -- Показывать источник диагностики (eslint, typescript и т.д.)
          show_source = false,

          -- Throttle обновлений (ms)
          throttle = 20,

          -- Мульти-линейные сообщения
          multilines = true,

          -- Показывать все диагностики на строке
          show_all_diags_on_cursorline = false,

          -- Padding и стиль
          softwrap = 30,

          -- Overflow handling
          overflow = {
            mode = "wrap", -- "wrap", "none", "oneline"
          },

          -- Отступ от текста
          virt_texts = {
            priority = 2048,
          },

          -- Включить для всех severity
          severity = {
            vim.diagnostic.severity.ERROR,
            vim.diagnostic.severity.WARN,
            vim.diagnostic.severity.INFO,
            vim.diagnostic.severity.HINT,
          },
        },

        -- Кастомные цвета (Nord theme)
        blend = {
          factor = 0.22,
        },

        hi = {
          error = "DiagnosticError",
          warn = "DiagnosticWarn",
          info = "DiagnosticInfo",
          hint = "DiagnosticHint",
          arrow = "NonText",
          background = "CursorLine",
          mixing_color = "#2E3440",
        },
      })
    end,
  },
}

