return {
  -- Go поддержка через LazyVim extra
  { import = "lazyvim.plugins.extras.lang.go" },

  -- go.nvim - расширенные фичи для Go разработки
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    event = { "CmdlineEnter" },
    ft = { "go", "gomod", "gosum", "gowork", "gotmpl" },
    -- Убрали build - инструменты устанавливаются через Mason
    opts = {
      -- Отключаем LSP go.nvim - используем gopls из LazyVim
      lsp_cfg = false,
      -- Отключаем keymaps go.nvim - используем свои
      lsp_keymaps = false,
      -- Диагностика
      diagnostic = {
        hdlr = true,
        underline = true,
        virtual_text = { spacing = 2, prefix = "●" },
        signs = true,
        update_in_insert = false,
      },
      -- Линтер
      linter = "golangci-lint",
      linter_flags = { "--fast" },
      -- Тестирование
      test_runner = "go",
      run_in_floaterm = true,
      floaterm = {
        position = "bottom",
        width = 0.99,
        height = 0.4,
      },
      -- Теги структур
      tag_transform = "snakecase",
      tag_options = "json=omitempty",
      -- Иконки
      icons = { breakpoint = "🔴", currentpos = "👉" },
      -- Авто-заполнение тегов структур
      textobjects = true,
      -- Подсветка покрытия тестами
      test_efm = true,
      -- Авто-форматирование при сохранении
      lsp_document_formatting = false, -- используем conform.nvim
    },
    config = function(_, opts)
      require("go").setup(opts)

      -- Автокоманда для Go файлов
      local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          -- Организация импортов при сохранении
          require("go.format").goimports()
        end,
        group = format_sync_grp,
      })
    end,
    keys = {
      -- Тестирование
      { "<leader>gt", "<cmd>GoTest<cr>", desc = "Go Test", ft = "go" },
      { "<leader>gT", "<cmd>GoTestFunc<cr>", desc = "Go Test Function", ft = "go" },
      { "<leader>gc", "<cmd>GoCoverage<cr>", desc = "Go Coverage", ft = "go" },
      -- Генерация
      { "<leader>ga", "<cmd>GoAddTag<cr>", desc = "Add Tags", ft = "go" },
      { "<leader>gr", "<cmd>GoRmTag<cr>", desc = "Remove Tags", ft = "go" },
      { "<leader>gi", "<cmd>GoImpl<cr>", desc = "Implement Interface", ft = "go" },
      { "<leader>gf", "<cmd>GoFillStruct<cr>", desc = "Fill Struct", ft = "go" },
      { "<leader>ge", "<cmd>GoIfErr<cr>", desc = "Add if err", ft = "go" },
      -- Навигация
      { "<leader>gd", "<cmd>GoDoc<cr>", desc = "Go Doc", ft = "go" },
      { "<leader>gD", "<cmd>GoDocBrowser<cr>", desc = "Go Doc Browser", ft = "go" },
      -- Запуск
      { "<leader>gR", "<cmd>GoRun<cr>", desc = "Go Run", ft = "go" },
      -- Модули
      { "<leader>gm", "<cmd>GoModTidy<cr>", desc = "Go Mod Tidy", ft = "go" },
      { "<leader>gM", "<cmd>GoModInit<cr>", desc = "Go Mod Init", ft = "go" },
      -- Альтернативный файл (тест <-> код)
      { "<leader>gA", "<cmd>GoAlt<cr>", desc = "Go Alternate File", ft = "go" },
    },
  },
}

