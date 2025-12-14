return {
  -- Дополнительные настройки LSP для Go
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Gopls - основной LSP для Go
        gopls = {
          settings = {
            gopls = {
              -- Анализ
              analyses = {
                unusedparams = true,
                shadow = true,
                fieldalignment = true,
                nilness = true,
                unusedwrite = true,
                useany = true,
              },
              -- Статический анализ
              staticcheck = true,
              -- Подсказки (inlay hints)
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              -- Код линзы
              codelenses = {
                gc_details = true,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              -- Эксперименты
              experimentalPostfixCompletions = true,
              -- Форматирование
              gofumpt = true,
              -- Семантические токены
              semanticTokens = true,
              -- Режим сборки
              buildFlags = { "-tags=integration,e2e" },
              -- Директория для анализа
              directoryFilters = {
                "-.git",
                "-.vscode",
                "-.idea",
                "-node_modules",
                "-vendor",
              },
              -- Символы
              symbolMatcher = "fuzzy",
              symbolStyle = "dynamic",
              -- UI
              usePlaceholders = true,
              completeUnimported = true,
              -- Vulncheck
              vulncheck = "Imports",
            },
          },
        },
      },
    },
  },
}

