-- local semantic = require("config.semantic-tokens")
local sc = require("config.palette")

--- Иконки git в Snacks explorer / pickers (буквы). Тот же объект и в opts, и в доп. merge в config.
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

--- Snacks не красит basename по диагностике; подмена только для ERROR (см. highlights SnacksExplorerFileDiagnosticError).
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

return {
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nightfox").setup({
        options = {
          transparent = false,
          styles = {
            comments = "italic",
          },
        },
        groups = {
          all = {
            ["@comment"] = { fg = sc.comment, style = "italic" },
          },
        },
      })
      vim.cmd.colorscheme("nightfox")

      local hl = require("config.highlights")
      hl.apply()

      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "nightfox*",
        callback = function()
          -- semantic.apply_plugin_highlights()
          hl.apply()
        end,
      })
      -- semantic.apply_plugin_highlights()
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nightfox",
    },
  },

  {
    "brenoprata10/nvim-highlight-colors",
    opts = {
      render = "background",
      enable_named_colors = true,
      enable_tailwind = true,
    },
  },

  -- Имя как у LazyVim (`snacks.nvim`), иначе lazy может не смержить opts в тот же плагин, что вызывает setup().
  {
    "snacks.nvim",
    opts = {
      picker = {
        icons = {
          git = snacks_picker_git_icons,
        },
      },
    },
    config = function()
      patch_snacks_explorer_diag_filename()
      local P = Snacks.config.picker
      P.icons = P.icons or {}
      P.icons.git = vim.tbl_deep_extend("force", P.icons.git or {}, snacks_picker_git_icons)
    end,
  },
}
