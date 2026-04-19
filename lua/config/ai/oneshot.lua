local cfg = require("config.ai.config")
local buf = require("config.ai.buffer")

local M = {}

--- Короткая одноразовая правка через выбранный провайдер (stdin → stdout).
--- Запуск блокирующий (vim.system():wait()) — подходит для коротких задач.
--- Для длинных используй pane.send_* (tmux-интеграцию).
---
--- opts:
---   profile — опциональный профиль провайдера (для codex: -p <profile>).
function M.run(line1, line2, opts)
  opts = opts or {}
  vim.ui.input({ prompt = "AI (" .. cfg.get().active .. "): " }, function(instruction)
    if instruction == nil or instruction == "" then
      return
    end
    local provider, provider_opts = cfg.provider()
    local settings = vim.tbl_deep_extend("force", provider_opts, opts)
    local cwd = buf.workspace_root()
    local payload = buf.oneshot_payload(line1, line2, instruction)
    local argv = provider.oneshot_argv(cwd, settings)

    vim.notify(("%s exec… (%d lines)"):format(provider.name, line2 - line1 + 1), vim.log.levels.INFO, {
      title = "AI",
    })

    local out = vim.system(argv, {
      stdin = payload,
      text = true,
      cwd = cwd,
    }):wait()

    if out.code ~= 0 then
      local err = (out.stderr and out.stderr ~= "") and out.stderr or (out.stdout or "exec failed")
      vim.notify(err, vim.log.levels.ERROR, { title = "AI/" .. provider.name })
      return
    end
    buf.show_output(out.stdout, provider.name .. "-exec")
  end)
end

return M
