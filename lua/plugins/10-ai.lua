return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    cmd = {
      "AvanteAsk",
      "AvanteEdit",
      "AvanteFocus",
      "AvanteToggle",
      "AvanteRefresh",
      "AvanteBuild",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = function()
      local ai = require("config.ai.config").get()
      local av = ai.avante or {}
      local acp = av.acp or {}
      local acp_env = {}

      for key, env_name in pairs(acp.env or {}) do
        acp_env[key] = os.getenv(env_name)
      end

      return {
        provider = av.provider or "codex",
        instructions_file = av.instructions_file or "AGENTS.md",
        system_prompt = av.system_prompt_override,
        behaviour = {
          auto_set_keymaps = false,
        },
        acp_providers = {
          [av.provider or "codex"] = {
            command = acp.command or "npx",
            args = acp.args or { "-y", "-g", "@zed-industries/codex-acp" },
            env = acp_env,
          },
        },
      }
    end,
  },
}
