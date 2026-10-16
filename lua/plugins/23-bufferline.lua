return {
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      opts.highlights = opts.highlights or {}
      for _, name in ipairs({ "background", "buffer", "buffer_visible", "tab" }) do
        opts.highlights[name] = vim.tbl_extend("force", opts.highlights[name] or {}, {
          fg = require("config.palette").ui_muted,
        })
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

      -- Счётчики ошибок и предупреждений во вкладках.
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
