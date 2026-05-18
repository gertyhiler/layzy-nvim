local p = require("config.palette")

local M = {}

--- UI-only оверрайды поверх gbprod/nord.nvim.
--- Синтаксис (строки, комментарии, ключевые слова, функции, типы) — на стороне темы.
--- Здесь: git-статусы Snacks/gitsigns + диагностика с повышенным контрастом.

function M.apply()
  local set = vim.api.nvim_set_hl

  -- gitsigns (gutter)
  set(0, "GitSignsAdd", { fg = p.git_add })
  set(0, "GitSignsChange", { fg = p.git_change })
  set(0, "GitSignsDelete", { fg = p.git_delete })

  -- Snacks explorer / pickers: git-статусы
  set(0, "SnacksPickerGitStatusAdded", { fg = p.git_add })
  set(0, "SnacksPickerGitStatusUntracked", { fg = p.git_add })
  set(0, "SnacksPickerGitStatusStaged", { fg = p.git_add })
  set(0, "SnacksPickerGitStatusModified", { fg = p.git_change })
  set(0, "SnacksPickerGitStatusDeleted", { fg = p.git_delete })
  set(0, "SnacksPickerGitStatusRenamed", { fg = p.git_change })
  set(0, "SnacksPickerGitStatusCopied", { fg = p.git_change })
  set(0, "SnacksPickerGitStatusIgnored", { fg = p.git_ignored })
  set(0, "SnacksPickerGitStatusUnmerged", { fg = p.git_delete })

  -- Basename файла в дереве с diagnostic ERROR
  set(0, "SnacksExplorerFileDiagnosticError", {
    fg = p.diag_error,
    sp = p.diag_error,
    undercurl = true,
  })

  -- Повышенный контраст для DiagnosticError в bufferline, tree и виртуальном тексте
  set(0, "DiagnosticError", { fg = p.diag_error, bold = true })
  set(0, "DiagnosticWarn", { fg = p.diag_warn })
end

return M
