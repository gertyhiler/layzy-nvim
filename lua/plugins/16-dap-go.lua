return {
  -- DAP (Debug Adapter Protocol) для Go
  { import = "lazyvim.plugins.extras.dap.core" },

  -- nvim-dap-go - интеграция с delve
  {
    "leoluz/nvim-dap-go",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    ft = "go",
    opts = {
      -- Путь к delve (автоопределение через Mason)
      delve = {
        path = "dlv",
        -- Инициализация при запуске
        initialize_timeout_sec = 20,
        -- Порт для подключения
        port = "${port}",
        -- Аргументы delve
        args = {},
        -- Флаги сборки
        build_flags = "",
        -- Режим отладки (debug, test, exec)
        detached = vim.fn.has("win32") == 0,
      },
      -- Конфигурации запуска
      dap_configurations = {
        {
          type = "go",
          name = "Debug Package",
          request = "launch",
          program = "${fileDirname}",
        },
        {
          type = "go",
          name = "Debug Test File",
          request = "launch",
          mode = "test",
          program = "${file}",
        },
        {
          type = "go",
          name = "Debug Test Package",
          request = "launch",
          mode = "test",
          program = "${fileDirname}",
        },
        {
          type = "go",
          name = "Attach to Process",
          request = "attach",
          mode = "local",
          processId = function()
            return require("dap.utils").pick_process()
          end,
        },
      },
    },
    config = function(_, opts)
      require("dap-go").setup(opts)
    end,
    keys = {
      -- Дебаг
      { "<leader>dg", "", desc = "+Go Debug", ft = "go" },
      {
        "<leader>dgt",
        function()
          require("dap-go").debug_test()
        end,
        desc = "Debug Go Test",
        ft = "go",
      },
      {
        "<leader>dgT",
        function()
          require("dap-go").debug_last_test()
        end,
        desc = "Debug Last Go Test",
        ft = "go",
      },
    },
  },

  -- Виртуальный текст для дебага
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = {
      enabled = true,
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
      commented = false,
      only_first_definition = true,
      all_references = false,
      clear_on_continue = false,
      virt_text_pos = "eol",
    },
  },

  -- Улучшенный UI для DAP
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    opts = {
      icons = {
        expanded = "▾",
        collapsed = "▸",
        current_frame = "▸",
      },
      mappings = {
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.33 },
            { id = "breakpoints", size = 0.17 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 0.33,
          position = "right",
        },
        {
          elements = {
            { id = "repl", size = 0.45 },
            { id = "console", size = 0.55 },
          },
          size = 0.27,
          position = "bottom",
        },
      },
      floating = {
        max_height = 0.9,
        max_width = 0.5,
        border = "rounded",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      controls = {
        enabled = true,
        element = "repl",
        icons = {
          pause = "",
          play = "",
          step_into = "",
          step_over = "",
          step_out = "",
          step_back = "",
          run_last = "",
          terminate = "",
        },
      },
    },
  },
}

