local p = require("config.palette")

local M = {}

function M.apply()
  local set = vim.api.nvim_set_hl

  -- set(0, "Comment", { fg = p.comment, italic = true })
  set(0, "Function", { fg = p.func })
  set(0, "@function", { fg = p.func })
  set(0, "Keyword", { fg = p.keyword })
  set(0, "@keyword", { fg = p.keyword })
  set(0, "Type", { fg = p.type })
  set(0, "@type", { fg = p.type })
  set(0, "String", { fg = p.string })
  set(0, "Number", { fg = p.number })

  set(0, "GitSignsAdd", { fg = p.git_add })
  set(0, "GitSignsChange", { fg = p.git_change })
  set(0, "GitSignsDelete", { fg = p.git_delete })

  -- Snacks Explorer / pickers (LazyVim)
  set(0, "SnacksPickerFile", { fg = p.fg })
  set(0, "SnacksExplorerFileDiagnosticError", {
    fg = p.git_delete,
    sp = p.git_delete,
    underline = true,
  })
  set(0, "SnacksPickerGitStatusAdded", { fg = p.git_add })
  set(0, "SnacksPickerGitStatusUntracked", { fg = p.git_add })
  set(0, "SnacksPickerGitStatusStaged", { fg = p.git_add })
  set(0, "SnacksPickerGitStatusModified", { fg = p.git_change })
  set(0, "SnacksPickerGitStatusDeleted", { fg = p.git_delete })
  set(0, "SnacksPickerGitStatusRenamed", { fg = p.git_change })
  set(0, "SnacksPickerGitStatusCopied", { fg = p.git_change })
  set(0, "SnacksPickerGitStatusIgnored", { fg = p.fg_muted })
  set(0, "SnacksPickerGitStatusUnmerged", { fg = p.git_delete })

  set(0, "DiffAdd", { bg = p.diff_add_bg })
  set(0, "DiffChange", { bg = p.diff_change_bg })
  set(0, "DiffDelete", { bg = p.diff_delete_bg })
end

return M
