return {
  -- Красивые inline диагностики с padding и скруглениями
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    priority = 1000,
    init = function()
      vim.diagnostic.config({ virtual_text = false })
    end,
    config = function()
      -- Берём bg из активной темы; при LspAttach colorscheme уже установлена
      local normal_bg = (function()
        local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = "Normal" })
        if ok and hl and hl.bg then
          return string.format("#%06x", hl.bg)
        end
        return "#2E3440" -- Nord Polar Night 0 fallback
      end)()

      require("tiny-inline-diagnostic").setup({
        preset = "modern",

        options = {
          show_source = false,
          throttle = 20,
          multilines = true,
          show_all_diags_on_cursorline = false,
          softwrap = 30,
          overflow = {
            mode = "wrap",
          },
          virt_texts = {
            priority = 2048,
          },
          severity = {
            vim.diagnostic.severity.ERROR,
            vim.diagnostic.severity.WARN,
            vim.diagnostic.severity.INFO,
            vim.diagnostic.severity.HINT,
          },
        },

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
          mixing_color = normal_bg,
        },
      })
    end,
  },
}
