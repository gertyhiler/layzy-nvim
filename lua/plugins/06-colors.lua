-- Snacks explorer/picker: буквенные иконки git-статусов.
local snacks_picker_git_icons = {
  enabled = true,
  staged = "S",
  added = "A",
  modified = "M",
  deleted = "D",
  renamed = "R",
  copied = "C",
  untracked = "U",
  ignored = "I",
  unmerged = "!",
}

--- Оверрайды из `config/highlights` после смены ColorScheme.
local function apply_overrides()
  require("config.highlights").apply()
end

return {
  -- Основная тема; синтаксис остаётся штатным.
  { "LazyVim/LazyVim", opts = { colorscheme = "tokyonight-moon" } },

  -- Регистрируем ColorScheme autocmd максимально рано
  {
    "folke/lazy.nvim",
    init = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("config_highlights_overrides", { clear = true }),
        callback = apply_overrides,
      })
      vim.schedule(apply_overrides)
    end,
  },

  {
    "brenoprata10/nvim-highlight-colors",
    opts = {
      render = "background",
      enable_named_colors = true,
      enable_tailwind = true,
    },
  },

  {
    "snacks.nvim",
    opts = {
      picker = {
        icons = {
          git = snacks_picker_git_icons,
        },
      },
    },
  },
}
