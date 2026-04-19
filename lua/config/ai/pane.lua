local cfg = require("config.ai.config")
local buf = require("config.ai.buffer")
local tmux = require("config.ai.tmux")

local M = {}

local function agent_title()
  return cfg.get().agent_pane_title or "agent"
end

--- Отправить произвольный текст в agent-pane и сабмитнуть Enter.
function M.send(text, opts)
  opts = vim.tbl_extend("force", { submit = true, focus = false }, opts or {})
  return tmux.send_to_title(agent_title(), text, opts)
end

--- Прикрепить текущий файл к сессии агента (как `@relpath`), без Enter —
--- часто хочется дописать prompt руками.
function M.attach_file()
  local provider = cfg.provider()
  local rel = buf.buf_relpath()
  local ref = provider.file_reference(rel) .. " "
  return M.send(ref, { submit = false, focus = true })
end

--- Прикрепить выделение (диапазон строк) как markdown-блок, без Enter.
function M.attach_selection(line1, line2)
  local snippet = buf.markdown_snippet(line1, line2) .. "\n"
  return M.send(snippet, { submit = false, focus = true })
end

--- Диалог «ask»: показать input, добавить выделение как контекст, отправить и сабмитнуть.
function M.ask(line1, line2)
  vim.ui.input({ prompt = "AI ask (" .. cfg.get().active .. "): " }, function(question)
    if not question or question == "" then
      return
    end
    local body = table.concat({
      question,
      "",
      buf.markdown_snippet(line1, line2),
    }, "\n")
    M.send(body, { submit = true, focus = true })
  end)
end

--- Просто перейти в agent pane.
function M.focus()
  local pane = tmux.find_pane_by_title(agent_title())
  if not pane then
    vim.notify("AI: agent pane not found", vim.log.levels.WARN, { title = "AI" })
    return
  end
  tmux.select_pane(pane)
end

return M
