if true return {}

return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>aa",
      function()
        require("avante").toggle()
      end,
      desc = "Toggle AI Chat",
    },
    {
      "<leader>ap",
      function()
        require("avante").toggle("planning")
      end,
      desc = "AI Planning Mode",
    },
    {
      "<leader>ae",
      function()
        require("avante").toggle("editing")
      end,
      desc = "AI Editing Mode",
    },
    {
      "<leader>as",
      function()
        require("avante").toggle("suggesting")
      end,
      desc = "AI Suggesting Mode",
    },
    {
      "<leader>ac",
      function()
        require("avante").toggle("chat")
      end,
      desc = "AI Chat Mode",
    },
    {
      "<leader>af",
      function()
        require("avante").toggle("chat", { files = { vim.fn.expand("%") } })
      end,
      desc = "AI Chat with Current File",
    },
    {
      "<leader>aP",
      function()
        require("avante").toggle("planning", { files = { vim.fn.expand("%") } })
      end,
      desc = "AI Plan with Current File",
    },
  },
  opts = {
    -- Основные настройки
    provider = "anthropic",
    
    -- Настройки интерфейса
    ui = {
      border = "rounded",
      width = 0.8,
      height = 0.8,
    },
    
    -- Настройки селектора файлов
    selector = {
      exclude_auto_select = { "NvimTree", "TelescopePrompt", "TelescopeResults" },
    },
    
    -- Настройки правил
    rules = {
      project_dir = ".avante/rules",
      global_dir = "~/.config/avante/rules",
    },
    
    -- Настройки переопределения промптов
    override_prompt_dir = vim.fn.expand("~/.config/nvim/avante_prompts"),
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function(_, opts)
    require("avante").setup(opts)
    -- Инициализация дополнительной конфигурации
    require("config.avante").setup()
  end,
} 
