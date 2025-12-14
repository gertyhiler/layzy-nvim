-- if true then
--  return {}
-- end

return {
  "amitds1997/remote-nvim.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  event = "VeryLazy",
  opts = {
    -- SSH: читаем хосты из обычного ~/.ssh/config
    ssh_config = {
      ssh_binary = "ssh",
      scp_binary = "scp",
      ssh_config_file_paths = { "$HOME/.ssh/config" },
      ssh_prompts = {
        { match = "password:", type = "secret", value_type = "static", value = "" },
        { match = "continue connecting (yes/no/[fingerprint])?", type = "plain", value_type = "static", value = "" },
      },
    },

    -- UI прогресса
    progress_view = { type = "popup" },

    -- Offline режим (по умолчанию выключен)
    offline_mode = {
      enabled = false,
      no_github = false,
      -- cache_dir: используем дефолт плагина
    },

    -- ВАЖНО: используем конфиг удалённой машины и ничего не копируем сверху
    remote = {
      app_name = "remote-nvim", -- использовать стандартный конфиг удалённого Neovim
      copy_dirs = {
        -- Копируем весь локальный конфиг на удалённый хост
        config = {
          base = vim.fn.stdpath("config"),
          dirs = "*", -- копировать всё содержимое конфига
          compression = { enabled = true, additional_opts = {} }, -- tar вместо scp для надёжности
        },
        data = { base = vim.fn.stdpath("data"), dirs = {}, compression = { enabled = true } },
        cache = { base = vim.fn.stdpath("cache"), dirs = {}, compression = { enabled = true } },
        state = { base = vim.fn.stdpath("state"), dirs = {}, compression = { enabled = true } },
      },
    },

    -- Локальный UI-клиент для подключения к удалённому серверу
    client_callback = function(port, _)
      require("remote-nvim.ui").float_term(("nvim --server localhost:%s --remote-ui"):format(port), function(exit_code)
        if exit_code ~= 0 then
          vim.notify(("Local client failed with exit code %s"):format(exit_code), vim.log.levels.ERROR)
        end
      end)
    end,
  },

  config = function(_, opts)
    require("remote-nvim").setup(opts)
  end,
}
