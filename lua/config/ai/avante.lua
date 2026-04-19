local cfg = require("config.ai.config")
local buf = require("config.ai.buffer")

local M = {}

local function avante_cfg()
  return (cfg.get().avante or {})
end

local function acp_command_available()
  local acp = avante_cfg().acp or {}
  local cmd = acp.command or "npx"
  return vim.fn.executable(cmd) == 1
end

local function compatible_with_active_provider()
  return cfg.get().active == (avante_cfg().provider or "codex")
end

function M.available()
  if avante_cfg().enabled == false then
    return false, "avante frontend is disabled"
  end
  if not compatible_with_active_provider() then
    return false, ("active provider '%s' is not integrated with avante in v1"):format(cfg.get().active)
  end
  if not acp_command_available() then
    return false, "avante ACP bridge command is unavailable"
  end
  local ok = pcall(require, "avante.api")
  if not ok then
    return false, "avante.nvim is not available"
  end
  return true
end

--- ask/chat через Avante. Вопрос берём у пользователя,
--- а текущий контекст (range) прикладываем прямо в текст запроса.
function M.ask(line1, line2)
  local ok, reason = M.available()
  if not ok then
    return false, reason
  end

  vim.ui.input({ prompt = "AI ask (codex/avante): " }, function(question)
    if not question or question == "" then
      return
    end
    local request = table.concat({
      question,
      "",
      "Context:",
      buf.markdown_snippet(line1, line2),
    }, "\n")

    local api = require("avante.api")
    local sent = pcall(api.ask, { question = request, ask = true })
    if not sent then
      vim.notify("AI: avante ask failed, fallback to tmux/cli is available", vim.log.levels.WARN, { title = "AI" })
    end
  end)

  return true
end

--- Edit flow Avante на диапазоне/выделении.
function M.edit(line1, line2)
  local ok, reason = M.available()
  if not ok then
    return false, reason
  end

  local api = require("avante.api")
  local success, err = pcall(api.edit, nil, line1, line2)
  if not success then
    return false, tostring(err)
  end
  return true
end

return M
