local M = {
  name = "claude",
  cmd = "claude",
}

--- `claude -p "<prompt>"` = одноразовый non-interactive запрос.
--- Мы подаём payload на stdin через `--print -`, чтобы поддержать многострочный payload.
function M.oneshot_argv(_cwd, _opts)
  -- claude читает stdin если не указан prompt; --print → печатать ответ и выйти.
  return { M.cmd, "--print" }
end

--- В TUI (`claude`) референс к файлу — тоже `@path`.
function M.file_reference(relpath)
  return "@" .. relpath
end

return M
