return {
  -- Mason инструменты для Go разработки
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- LSP
        "gopls",
        -- Линтер
        "golangci-lint",
        "golangci-lint-langserver",
        -- Форматирование
        "gofumpt",
        "goimports",
        "goimports-reviser",
        -- Дебаггер
        "delve",
        -- Тулинг
        "gomodifytags",
        "gotests",
        "impl",
        "iferr",
        -- JSON/YAML
        "json-to-struct",
      })
    end,
  },
}

