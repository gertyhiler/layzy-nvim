local M = {}

-- UI-only токены — строки/комментарии/синтаксис на стороне gbprod/nord.nvim.

-- Git / Snacks (Nord Aurora palette)
M.git_add    = "#A3BE8C" -- Nord14
M.git_change = "#EBCB8B" -- Nord13
M.git_delete = "#BF616A" -- Nord11
M.git_ignored = "#4C566A" -- Nord3

-- Diagnostic overrides (повышенный контраст для bufferline и tree)
M.diag_error = "#BF616A" -- Nord11
M.diag_warn  = "#EBCB8B" -- Nord13

return M
