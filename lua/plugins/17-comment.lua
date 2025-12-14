return {
  -- Комментирование кода
  {
    "numToStr/Comment.nvim",
    dependencies = {
      -- Поддержка JSX/TSX комментариев
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    keys = {
      -- Комментирование через <leader>/
      {
        "<leader>/",
        function()
          require("Comment.api").toggle.linewise.current()
        end,
        desc = "Toggle comment",
        mode = "n",
      },
      {
        "<leader>/",
        "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
        desc = "Toggle comment",
        mode = "v",
      },
    },
    opts = {
      -- Использовать treesitter для определения типа комментария (JSX/TSX)
      pre_hook = function(ctx)
        local U = require("Comment.utils")
        local location = nil

        if ctx.ctype == U.ctype.blockwise then
          location = require("ts_context_commentstring.utils").get_cursor_location()
        elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
          location = require("ts_context_commentstring.utils").get_visual_start_location()
        end

        return require("ts_context_commentstring.internal").calculate_commentstring({
          key = ctx.ctype == U.ctype.linewise and "__default" or "__multiline",
          location = location,
        })
      end,
    },
  },

  -- Настройка ts-context-commentstring
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
  },
}

