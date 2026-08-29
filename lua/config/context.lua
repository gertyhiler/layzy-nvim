local M = {}

local function workspace_root()
  local name = vim.api.nvim_buf_get_name(0)
  local path = name ~= "" and vim.fn.fnamemodify(name, ":p") or vim.fn.getcwd(0)
  return vim.fs.root(path, ".git") or vim.fn.fnamemodify(path, name ~= "" and ":h" or ":p")
end

local function relative_path()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    return "[No Name]"
  end

  local root = workspace_root()
  local absolute = vim.fn.fnamemodify(name, ":p")
  if root and absolute:sub(1, #root + 1) == root .. "/" then
    return absolute:sub(#root + 2)
  end
  return absolute
end

local function selected_range()
  if vim.fn.mode():match("[vV\22]") then
    local first = vim.fn.line("v")
    local last = vim.fn.line(".")
    return math.min(first, last), math.max(first, last)
  end
  local line = vim.fn.line(".")
  return line, line
end

local function line_range_text(first, last)
  return table.concat(vim.api.nvim_buf_get_lines(0, first - 1, last, true), "\n")
end

local function selection_text()
  local mode = vim.fn.mode()
  local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), {
    type = mode,
    exclusive = vim.o.selection == "exclusive",
  })
  return table.concat(lines, "\n")
end

local function selected_text(first, last)
  if vim.fn.mode():match("[vV\22]") then
    return selection_text()
  end
  return line_range_text(first, last)
end

local function copy(text, label)
  vim.fn.setreg('"', text, "v")
  require("vim.ui.clipboard.osc52").copy("+")(vim.split(text, "\n", { plain = true }))
  vim.notify(label, vim.log.levels.INFO, { title = "Context" })
end

function M.copy_selection()
  local first, last = selected_range()
  copy(selection_text(), ("Copied lines %d-%d"):format(first, last))
end

function M.copy_file()
  copy(relative_path(), "Copied file path")
end

function M.copy_reference()
  local first, last = selected_range()
  local suffix = first == last and tostring(first) or ("%d-%d"):format(first, last)
  copy(("%s:%s"):format(relative_path(), suffix), "Copied file reference")
end

function M.copy_context()
  local first, last = selected_range()
  local suffix = first == last and tostring(first) or ("%d-%d"):format(first, last)
  local text = table.concat({
    ("%s:%s"):format(relative_path(), suffix),
    "",
    "```" .. vim.bo.filetype,
    selected_text(first, last),
    "```",
  }, "\n")
  copy(text, "Copied code context")
end

return M
