local M = {}

--- Настройки пользователя + runtime state.
--- Меняется через :AiProvider <name> или M.set_active("claude").
M.defaults = {
  --- Активный провайдер по имени ключа в providers/.
  active = "codex",
  --- tmux pane title, который считаем agent-панелью.
  agent_pane_title = "agent",
  --- Провайдеры (позволяем переопределять поля извне).
  providers = {
    codex = {},
    claude = {},
    cursor_agent = {},
  },
}

M.state = vim.deepcopy(M.defaults)

function M.setup(opts)
  M.state = vim.tbl_deep_extend("force", M.defaults, opts or {})
end

function M.get()
  return M.state
end

function M.set_active(name)
  if not M.state.providers[name] then
    vim.notify("AI: unknown provider: " .. tostring(name), vim.log.levels.ERROR, { title = "AI" })
    return
  end
  M.state.active = name
  vim.notify("AI provider → " .. name, vim.log.levels.INFO, { title = "AI" })
end

function M.provider(name)
  name = name or M.state.active
  local ok, mod = pcall(require, "config.ai.providers." .. name)
  if not ok then
    error("ai provider not found: " .. name)
  end
  return mod, vim.tbl_deep_extend("force", {}, M.state.providers[name] or {})
end

return M
