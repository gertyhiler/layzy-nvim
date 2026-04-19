local buf = require("config.ai.buffer")
local oneshot = require("config.ai.oneshot")
local router = require("config.ai.router")
local cfg = require("config.ai.config")

local M = {}

--- Хелпер: достать visual range или fallback на текущую строку.
local function get_range()
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then
    local a, b = buf.visual_range()
    return a, b
  end
  local line = vim.fn.line(".")
  return line, line
end

function M.setup()
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
  end

  --- ── One-shot (блокирующие, быстрые правки через stdin) ──────────────────
  vim.api.nvim_create_user_command("AiExec", function(o)
    oneshot.run(o.line1, o.line2, { profile = (cfg.get().providers[cfg.get().active] or {}).profile_edit })
  end, { range = true, desc = "AI one-shot exec на диапазоне" })

  vim.api.nvim_create_user_command("AiExecRead", function(o)
    oneshot.run(o.line1, o.line2, { profile = (cfg.get().providers[cfg.get().active] or {}).profile_read })
  end, { range = true, desc = "AI one-shot exec (read profile)" })

  map("v", "<leader>ae", function()
    local a, b = buf.visual_range()
    router.edit(a, b)
  end, "AI: edit selection (routed frontend)")

  map("v", "<leader>ar", function()
    local a, b = buf.visual_range()
    router.read(a, b)
  end, "AI: one-shot read (selection)")

  --- ── Tmux pane: длинные/параллельные задачи ─────────────────────────────
  map("n", "<leader>ap", router.focus_pane, "AI: focus agent pane")

  map("n", "<leader>af", router.attach_file, "AI: attach current file to agent pane")

  map("v", "<leader>as", function()
    local a, b = buf.visual_range()
    router.attach_selection(a, b)
  end, "AI: send selection to agent pane")

  map({ "n", "v" }, "<leader>aa", function()
    local a, b = get_range()
    router.ask(a, b)
  end, "AI: ask agent (routed frontend)")

  --- ── Переключение провайдера ────────────────────────────────────────────
  vim.api.nvim_create_user_command("AiProvider", function(o)
    if o.args == "" then
      vim.notify("AI active = " .. cfg.get().active, vim.log.levels.INFO, { title = "AI" })
      return
    end
    cfg.set_active(o.args)
  end, {
    nargs = "?",
    complete = function()
      return vim.tbl_keys(cfg.get().providers)
    end,
    desc = "Показать/переключить активный AI-провайдер",
  })

  --- ── Режим фронтендов (hybrid/legacy) ────────────────────────────────────
  vim.api.nvim_create_user_command("AiFrontend", function(o)
    if o.args == "" then
      vim.notify("AI frontend mode = " .. (cfg.get().frontend_mode or "hybrid"), vim.log.levels.INFO, { title = "AI" })
      return
    end
    cfg.set_frontend_mode(o.args)
  end, {
    nargs = "?",
    complete = function()
      return { "hybrid", "legacy" }
    end,
    desc = "Показать/переключить режим AI-фронтенда",
  })

  vim.api.nvim_create_user_command("AiFrontendToggle", function()
    cfg.toggle_frontend_mode()
  end, {
    desc = "Переключить режим AI-фронтенда (hybrid <-> legacy)",
  })

  map("n", "<leader>aA", function()
    vim.ui.select(vim.tbl_keys(cfg.get().providers), { prompt = "AI provider:" }, function(choice)
      if choice then
        cfg.set_active(choice)
      end
    end)
  end, "AI: choose provider")

  map("n", "<leader>aM", function()
    vim.ui.select({ "hybrid", "legacy" }, { prompt = "AI frontend mode:" }, function(choice)
      if choice then
        cfg.set_frontend_mode(choice)
      end
    end)
  end, "AI: choose frontend mode")
end

return M
