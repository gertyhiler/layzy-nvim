local p = require("config.palette")

local M = {}

-- Navigation and unnecessary-code contrast; other colors belong to Tokyo Night Moon.

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

  -- Keep hidden and ignored names readable without changing NonText globally.
  set(0, "SnacksPickerPathHidden", { fg = p.ui_muted })
  set(0, "SnacksPickerPathIgnored", { fg = p.ui_muted })

  -- Unused/unreachable code must remain readable.
  set(0, "DiagnosticUnnecessary", { fg = "#696e8c" })
end

return M
