--- blink.cmp polish: убираем шум (авто-docs popup, ghost text) без изменения
--- accept-on-Enter и cmdline completion.
--- Tailwind color swatch: реализация через blink draw components — отложено,
--- nvim-highlight-colors (06-colors.lua) уже красит hex в редакторе.

return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        documentation = {
          -- Docs показываем только вручную (<C-k>), не при каждом движении по меню
          auto_show = false,
        },
        ghost_text = {
          -- Ghost text только для AI-провайдеров (vim.g.ai_cmp), не для обычного LSP
          enabled = false,
        },
      },
    },
  },
}
