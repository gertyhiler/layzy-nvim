local M = {}

--- Настройки пользователя + runtime state.
--- Меняется через :AiProvider <name> или M.set_active("claude").
M.defaults = {
  --- Активный провайдер по имени ключа в providers/.
  active = "codex",
  --- tmux pane title, который считаем agent-панелью.
  agent_pane_title = "agent",
  --- Режим маршрутизации фронтендов:
  ---   hybrid = ask/edit через frontends.* (по умолчанию avante),
  ---   legacy = возврат к старому поведению (ask->tmux, edit->oneshot).
  frontend_mode = "hybrid",
  --- Явная маршрутизация по типу взаимодействия.
  frontends = {
    ask = "avante",
    edit = "avante",
    pane = "tmux",
    oneshot = "cli",
  },
  --- Avante как опциональный фронтенд над тем же contract (AGENTS.md).
  avante = {
    enabled = true,
    provider = "codex",
    instructions_file = "AGENTS.md",
    acp = {
      command = "npx",
      args = { "-y", "-g", "@zed-industries/codex-acp" },
      env = {
        NODE_NO_WARNINGS = "1",
        OPENAI_API_KEY = "OPENAI_API_KEY",
      },
    },
    system_prompt_override = table.concat({
      "AGENTS.md is authoritative for this workspace.",
      "If AGENTS.md references .agents/skills, follow those references.",
      "Do not assume Avante-specific instruction files exist.",
    }, "\n"),
  },
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

function M.set_frontend_mode(mode)
  if mode ~= "hybrid" and mode ~= "legacy" then
    vim.notify("AI: unknown frontend mode: " .. tostring(mode), vim.log.levels.ERROR, { title = "AI" })
    return
  end
  M.state.frontend_mode = mode
  vim.notify("AI frontend mode → " .. mode, vim.log.levels.INFO, { title = "AI" })
end

function M.toggle_frontend_mode()
  if M.state.frontend_mode == "hybrid" then
    M.set_frontend_mode("legacy")
  else
    M.set_frontend_mode("hybrid")
  end
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
