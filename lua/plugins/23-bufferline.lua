return {
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      -- Nord native bufferline highlights (must call после того, как nord.nvim загружен)
      local ok, nb = pcall(require, "nord.plugins.bufferline")
      if ok then
        opts.highlights = nb.akinsho()
      end

      opts.options = opts.options or {}

      -- Git decoration: добавляем суффикс ~ к имени таба если в файле есть gitsigns-изменения.
      -- Порядок табов не меняется (не используем groups).
      opts.options.name_formatter = function(buf)
        local ok2, status = pcall(function()
          return vim.b[buf.bufnr].gitsigns_status_dict
        end)
        if ok2 and status then
          local n = (status.added or 0) + (status.changed or 0) + (status.removed or 0)
          if n > 0 then
            return buf.name .. " ~"
          end
        end
      end

      -- Более заметный diagnostic indicator: крест для error, треугольник для warn + счётчик.
      -- DiagnosticError {bold=true} из highlights.lua делает hl группу контрастнее.
      opts.options.diagnostics_indicator = function(count, level, diag, _ctx)
        local s = ""
        if diag.error and diag.error > 0 then
          s = s .. " " .. diag.error
        end
        if diag.warning and diag.warning > 0 then
          s = s .. " " .. diag.warning
        end
        return vim.trim(s)
      end
    end,
  },
}
