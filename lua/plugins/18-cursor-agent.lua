return {
  -- Cursor Agent - интеграция Cursor AI в Neovim
  {
    "xTacobaco/cursor-agent.nvim",
    cmd = { "CursorAgent", "CursorAgentSelection", "CursorAgentBuffer" },
    keys = {
      -- Основные команды
      { "<leader>ca", "<cmd>CursorAgent<cr>", desc = "Cursor Agent: Toggle terminal", mode = "n" },
      { "<leader>ca", "<cmd>CursorAgentSelection<cr>", desc = "Cursor Agent: Send selection", mode = "v" },
      { "<leader>cA", "<cmd>CursorAgentBuffer<cr>", desc = "Cursor Agent: Send buffer", mode = "n" },
    },
    opts = {
      -- Настройки floating window
      window = {
        width = 0.8,
        height = 0.8,
        border = "rounded",
      },
    },
    config = function(_, opts)
      require("cursor-agent").setup(opts)
    end,
  },
}

