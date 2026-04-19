local M = {
  name = "cursor_agent",
  cmd = "cursor-agent",
}

--- cursor-agent -p "<prompt>" — one-shot. Передаём prompt на stdin → агрументом оставляем пустым не можем,
--- поэтому строим команду с --print и пишем payload в stdin (agent 2026+ поддерживает stdin).
function M.oneshot_argv(_cwd, _opts)
  return { M.cmd, "--print" }
end

function M.file_reference(relpath)
  return "@" .. relpath
end

return M
