local M = {}

--- Корень проекта для текущего буфера: .git → вверх → fallback на cwd/директорию файла.
function M.workspace_root()
  local name = vim.api.nvim_buf_get_name(0)
  local path = name ~= "" and vim.fn.fnamemodify(name, ":p") or vim.fn.getcwd(0)
  return vim.fs.root(path, ".git") or vim.fn.fnamemodify(path, name ~= "" and ":h" or ":p")
end

--- Путь текущего буфера относительно workspace_root (или абсолютный, если вне корня).
function M.buf_relpath()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    return "[No Name]"
  end
  local root = M.workspace_root()
  local abs = vim.fn.fnamemodify(name, ":p")
  if root and abs:sub(1, #root + 1) == root .. "/" then
    return abs:sub(#root + 2)
  end
  return abs
end

--- Содержимое диапазона строк [line1,line2] текущего буфера.
function M.range_lines(line1, line2)
  local lines = vim.api.nvim_buf_get_lines(0, line1 - 1, line2, true)
  return table.concat(lines, "\n")
end

--- Нормализовать visual-диапазон из callback-режима.
function M.visual_range()
  local a = vim.fn.line("v")
  local b = vim.fn.line(".")
  if a > b then
    a, b = b, a
  end
  return a, b
end

--- Markdown-блок: путь + строки + сам код в fence.
function M.markdown_snippet(line1, line2)
  return table.concat({
    ("File: %s  Lines %d-%d"):format(M.buf_relpath(), line1, line2),
    "```",
    M.range_lines(line1, line2),
    "```",
  }, "\n")
end

--- Полная payload для one-shot exec (инструкция + контекст).
function M.oneshot_payload(line1, line2, instruction)
  return table.concat({ instruction, "", M.markdown_snippet(line1, line2), "" }, "\n")
end

--- Показать длинный текст в split-буфере; короткий — через vim.notify.
function M.show_output(text, title)
  if not text or text == "" then
    return
  end
  if #text < 800 then
    vim.notify(text, vim.log.levels.INFO, { title = title })
    return
  end
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "markdown"
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(text, "\n"))
  vim.cmd.split()
  vim.api.nvim_win_set_buf(0, buf)
  vim.api.nvim_buf_set_name(buf, title)
end

return M
