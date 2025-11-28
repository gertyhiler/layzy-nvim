return {
  -- -- Тема Nord
  -- {
  --   "shaunsingh/nord.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   init = function()
  --     --     local api = require "nvim-tree.api"

  --     vim.g.nord_contrast = true
  --     vim.g.nord_borders = false
  --     vim.g.nord_disable_background = false
  --     vim.g.nord_cursorline_transparent = false
  --     vim.g.nord_enable_sidebar_background = false
  --     vim.g.nord_italic = true
  --     vim.g.nord_uniform_diff_background = false
  --     vim.g.nord_bold = true
  --   end,
  -- },

  -- -- Установка colorscheme для LazyVim
  -- {
  --   "LazyVim/LazyVim",
  --   opts = {
  --     colorscheme = "nord",
  --   },
  -- },

  "neanias/everforest-nvim",
  version = false,
  lazy = false,
  priority = 1000, -- make sure to load this before all the other start plugins
  -- Optional; default configuration will be used if setup isn't called.
  config = function()
    require("everforest").setup({
      -- Your config here
    })
  end,

  -- Подсветка цветов в CSS
  {
    "brenoprata10/nvim-highlight-colors",
    opts = {
      render = "background",
      enable_named_colors = true,
      enable_tailwind = true,
    },
  },
}
