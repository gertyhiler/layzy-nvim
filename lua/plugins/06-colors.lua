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

--- Snacks сам не красит basename по диагностике; подменяем formatter и красим
--- только когда severity == ERROR (см. highlights SnacksExplorerFileDiagnosticError).
local function patch_snacks_explorer_diag_filename()
  local ok, fmt = pcall(require, "snacks.picker.format")
  if not ok or fmt.__diag_filename_patched then
    return
  end
  fmt.__diag_filename_patched = true
  local orig = fmt.filename
  fmt.filename = function(item, picker)
    local is_err = item.severity == vim.diagnostic.severity.ERROR
    local prev = item.filename_hl
    if is_err then
      item.filename_hl = "SnacksExplorerFileDiagnosticError"
    end
    local ret = orig(item, picker)
    item.filename_hl = prev
    return ret
  end
end

--- Оверрайды из `config/highlights` после смены ColorScheme.
local function apply_overrides()
  require("config.highlights").apply()
end

return {
  -- Переопределяем встроенный LazyVim colorscheme на Nord
  { "LazyVim/LazyVim", opts = { colorscheme = "tokyonight-moon" } },

  -- Настоящий Nord (не carbonfox + overrides)
  -- {
  --   "gbprod/nord.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     -- Ошибки как fg-цвет (чище на тёмном фоне)
  --     errors = { mode = "fg" },
  --     search = { theme = "vim" },
  --     styles = {
  --       comments = { italic = true },
  --       -- Для bufferline-интеграции (23-bufferline.lua использует nord.plugins.bufferline)
  --       bufferline = {
  --         current = {},
  --         modified = { italic = true },
  --       },
  --     },
  --   },
  --   config = function(_, opts)
  --     require("nord").setup(opts)
  --   end,
  -- },

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
    -- init (не config) — не перебиваем LazyVim config, который вызывает setup()
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = patch_snacks_explorer_diag_filename,
      })
    end,
  },
}
