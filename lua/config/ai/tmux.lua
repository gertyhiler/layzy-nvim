local M = {}

local function in_tmux()
  return vim.env.TMUX ~= nil and vim.env.TMUX ~= ""
end

local function tmux(args, opts)
  opts = opts or {}
  local res = vim.system(vim.list_extend({ "tmux" }, args), {
    text = true,
    stdin = opts.stdin,
  }):wait()
  return res
end

--- Ищем pane по title во ВСЕХ окнах текущей сессии (а если вне tmux — пытаемся через -a).
--- Возвращает pane_id ("%NN") или nil.
function M.find_pane_by_title(title)
  if not in_tmux() then
    return nil
  end
  local args = { "list-panes", "-s", "-F", "#{pane_id} #{pane_title}" }
  local res = tmux(args)
  if res.code ~= 0 or not res.stdout then
    return nil
  end
  for line in res.stdout:gmatch("[^\r\n]+") do
    local id, ttl = line:match("^(%S+)%s+(.+)$")
    if id and ttl == title then
      return id
    end
  end
  return nil
end

--- Отправить многострочный текст в pane как bracketed paste, затем Enter для сабмита.
--- Возвращает true/false + err.
function M.send_text(pane_id, text, opts)
  opts = opts or {}
  if not in_tmux() then
    return false, "not inside tmux"
  end
  if not pane_id then
    return false, "no target pane"
  end

  -- Кладём текст в отдельный tmux-буфер (имя — уникальное, чтобы не конфликтовать).
  local buf_name = "nvim_ai_" .. tostring(vim.loop.hrtime())
  local set = tmux({ "set-buffer", "-b", buf_name, "-" }, { stdin = text })
  if set.code ~= 0 then
    return false, "tmux set-buffer failed: " .. (set.stderr or "")
  end

  -- -p = bracketed paste, -d = удалить буфер после вставки.
  local paste = tmux({ "paste-buffer", "-p", "-d", "-b", buf_name, "-t", pane_id })
  if paste.code ~= 0 then
    return false, "tmux paste-buffer failed: " .. (paste.stderr or "")
  end

  if opts.submit ~= false then
    -- Небольшая задержка, чтобы TUI успел принять paste до Enter.
    vim.loop.sleep(40)
    local enter = tmux({ "send-keys", "-t", pane_id, "Enter" })
    if enter.code ~= 0 then
      return false, "tmux send-keys failed: " .. (enter.stderr or "")
    end
  end

  return true
end

--- Переключиться на pane по id.
function M.select_pane(pane_id)
  if not in_tmux() or not pane_id then
    return false
  end
  local r = tmux({ "select-pane", "-t", pane_id })
  return r.code == 0
end

--- Удобный хелпер: "найти agent pane, отправить prompt, при желании переключиться".
function M.send_to_title(title, text, opts)
  local pane = M.find_pane_by_title(title)
  if not pane then
    vim.notify(
      ("AI: tmux pane with title '%s' not found.\nЗапусти сессию через `adev` или задай title: tmux select-pane -T %s"):format(
        title,
        title
      ),
      vim.log.levels.ERROR,
      { title = "AI/tmux" }
    )
    return false
  end
  local ok, err = M.send_text(pane, text, opts)
  if not ok then
    vim.notify("AI: " .. tostring(err), vim.log.levels.ERROR, { title = "AI/tmux" })
    return false
  end
  if opts and opts.focus then
    M.select_pane(pane)
  end
  return true
end

M.in_tmux = in_tmux

return M
