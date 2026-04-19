local cfg = require("config.ai.config")
local pane = require("config.ai.pane")
local oneshot = require("config.ai.oneshot")
local avante = require("config.ai.avante")

local M = {}

local function active_provider_opts()
  return cfg.get().providers[cfg.get().active] or {}
end

local function mode()
  return cfg.get().frontend_mode or "hybrid"
end

local function frontend_for(kind)
  if mode() == "legacy" then
    if kind == "ask" then
      return "tmux"
    end
    if kind == "edit" then
      return "cli"
    end
    return cfg.get().frontends[kind]
  end
  return cfg.get().frontends[kind]
end

function M.ask(line1, line2)
  local frontend = frontend_for("ask")
  if frontend == "avante" then
    local ok, reason = avante.ask(line1, line2)
    if ok then
      return
    end
    vim.notify("AI: avante unavailable (" .. tostring(reason) .. "), fallback to tmux pane", vim.log.levels.WARN, {
      title = "AI",
    })
  end
  pane.ask(line1, line2)
end

function M.edit(line1, line2)
  local frontend = frontend_for("edit")
  if frontend == "avante" then
    local ok, reason = avante.edit(line1, line2)
    if ok then
      return
    end
    vim.notify("AI: avante unavailable (" .. tostring(reason) .. "), fallback to one-shot", vim.log.levels.WARN, {
      title = "AI",
    })
  end

  oneshot.run(line1, line2, {
    profile = active_provider_opts().profile_edit,
  })
end

function M.read(line1, line2)
  oneshot.run(line1, line2, {
    profile = active_provider_opts().profile_read,
  })
end

function M.attach_selection(line1, line2)
  pane.attach_selection(line1, line2)
end

function M.attach_file()
  pane.attach_file()
end

function M.focus_pane()
  pane.focus()
end

return M
