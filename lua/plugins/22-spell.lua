--- Spell: два уровня.
--- 1. vim spell — включается автоматически для prose-буферов (markdown, gitcommit, text).
--- 2. CSpell через nvim-lint — включается только когда в репо есть cspell-конфиг.
---    Filetypes allow-list: код + prose (не весь editor, не случайные буферы).

local CSPELL_FT = {
  "go",
  "lua",
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "json",
  "yaml",
  "toml",
  "markdown",
  "gitcommit",
}

--- Ищем cspell-конфиг в дереве от текущего файла вверх.
local function has_cspell_config(ctx)
  return vim.fs.find({
    "cspell.json",
    ".cspell.json",
    "cspell.config.json",
    "cspell.config.yaml",
    "cspell.config.yml",
    "cspell.config.js",
    "cspell.config.cjs",
  }, { path = ctx.filename, upward = true })[1] ~= nil
end

return {
  -- vim spell: только prose-буферы, не весь редактор
  {
    "LazyVim/LazyVim",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("prose_spell", { clear = true }),
        pattern = { "markdown", "gitcommit", "text", "NeogitCommitMessage" },
        callback = function()
          vim.opt_local.spell = true
          vim.opt_local.spelllang = "en,ru"
        end,
      })
    end,
  },

  -- CSpell через nvim-lint (LazyVim уже подключает nvim-lint)
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      -- Добавляем cspell ко всем разрешённым типам файлов
      for _, ft in ipairs(CSPELL_FT) do
        opts.linters_by_ft[ft] = opts.linters_by_ft[ft] or {}
        -- Только если cspell ещё не зарегистрирован для этого ft
        if not vim.tbl_contains(opts.linters_by_ft[ft], "cspell") then
          table.insert(opts.linters_by_ft[ft], "cspell")
        end
      end

      opts.linters = opts.linters or {}
      -- Переопределяем cspell с condition: молчим если нет проектного конфига
      opts.linters.cspell = {
        condition = has_cspell_config,
      }
    end,
  },

  -- cspell CLI через Mason (Node >= 18 у тебя уже есть из avante/codex)
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if not vim.tbl_contains(opts.ensure_installed, "cspell") then
        table.insert(opts.ensure_installed, "cspell")
      end
    end,
  },
}
