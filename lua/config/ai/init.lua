local M = {}

--- Agent-agnostic AI-слой.
--- Архитектура:
---   config.lua        — дефолты + runtime (активный провайдер).
---   providers/*.lua   — описание CLI конкретного агента.
---   buffer.lua        — хелперы работы с буфером/диапазоном.
---   tmux.lua          — интеграция с tmux pane по pane_title.
---   oneshot.lua       — короткие правки через stdin (vim.system, блокирующе).
---   pane.lua          — длинные задачи: шлём в tmux-пане агента.
---   keymaps.lua       — единая <leader>a… карта + :AiProvider.
---   autoreload.lua    — :checktime на focus/enter, чтобы правки агента
---                       (codex/claude в другой pane) подхватывались.
function M.setup(opts)
  require("config.ai.autoreload").setup()
  require("config.ai.config").setup(opts or {})
  require("config.ai.keymaps").setup()
end

return M
