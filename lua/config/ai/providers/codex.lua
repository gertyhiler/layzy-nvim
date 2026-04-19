local M = {
  name = "codex",
  cmd = "codex",
}

--- argv для one-shot `codex exec` со stdin.
--- opts: { profile?: string }
function M.oneshot_argv(cwd, opts)
  local argv = { M.cmd, "exec" }
  if opts.profile and opts.profile ~= "" then
    argv[#argv + 1] = "-p"
    argv[#argv + 1] = opts.profile
  end
  argv[#argv + 1] = "-C"
  argv[#argv + 1] = cwd
  argv[#argv + 1] = "-"
  return argv
end

--- Как оформить ссылку на файл для interactive TUI агента (в pane).
--- Codex TUI понимает `@path` — это аттач файла.
function M.file_reference(relpath)
  return "@" .. relpath
end

return M
