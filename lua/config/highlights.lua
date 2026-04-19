local p = require("config.palette")

local M = {}

--- Оверрайды поверх активной темы: палитра в `config/palette.lua`.
--- Строки и комментарии — treesitter + базовые группы; папки — Snacks explorer/picker.

local STRING_GROUPS = {
  "String",
  "@string",
  "@string.documentation",
  "@string.special",
  "@string.escape",
  "@string.regexp",
  "@string.regex",
  "@character",
  "@character.special",
  "@lsp.type.string",
  "@markup.raw",
  "@markup.raw.block",
}

local COMMENT_GROUPS = {
  "Comment",
  "SpecialComment",
  "@comment",
  "@comment.documentation",
  -- @comment.error / @comment.warning — оставляем теме (диагностика)
  "@comment.todo",
  "@comment.note",
  "@lsp.type.comment",
}

function M.apply()
  local set = vim.api.nvim_set_hl

  local string_hl = { fg = p.string }
  for _, g in ipairs(STRING_GROUPS) do
    set(0, g, string_hl)
  end

  local comment_hl = { fg = p.comment, italic = true }
  for _, g in ipairs(COMMENT_GROUPS) do
    set(0, g, comment_hl)
  end

  -- Дерево / пикеры (имя папки и префикс пути)
  set(0, "SnacksPickerDirectory", { fg = p.folder })
  set(0, "SnacksPickerDir", { fg = p.folder })
  set(0, "Directory", { fg = p.folder })

  -- gitsigns (gutter)
  set(0, "GitSignsAdd", { fg = p.git_add })
  set(0, "GitSignsChange", { fg = p.git_change })
  set(0, "GitSignsDelete", { fg = p.git_delete })

  -- Snacks explorer / pickers: git-статусы и файл-с-ошибкой
  set(0, "SnacksPickerGitStatusAdded", { fg = p.git_add })
  set(0, "SnacksPickerGitStatusUntracked", { fg = p.git_add })
  set(0, "SnacksPickerGitStatusStaged", { fg = p.git_add })
  set(0, "SnacksPickerGitStatusModified", { fg = p.git_change })
  set(0, "SnacksPickerGitStatusDeleted", { fg = p.git_delete })
  set(0, "SnacksPickerGitStatusRenamed", { fg = p.git_change })
  set(0, "SnacksPickerGitStatusCopied", { fg = p.git_change })
  set(0, "SnacksPickerGitStatusIgnored", { fg = p.git_ignored })
  set(0, "SnacksPickerGitStatusUnmerged", { fg = p.git_delete })

  -- Basename файла в дереве с diagnostic ERROR (патч formatter в 06-colors.lua)
  set(0, "SnacksExplorerFileDiagnosticError", {
    fg = p.git_delete,
    sp = p.git_delete,
    underline = true,
  })
end

return M
