return {
  -- Treesitter парсеры для Go
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "go",
        "gomod",
        "gosum",
        "gowork",
        -- Для шаблонов (html/templ)
        "gotmpl",
      })
    end,
  },

  -- Текстовые объекты для Go
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    opts = {
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            -- Функции
            ["af"] = { query = "@function.outer", desc = "Select outer function" },
            ["if"] = { query = "@function.inner", desc = "Select inner function" },
            -- Классы/структуры
            ["ac"] = { query = "@class.outer", desc = "Select outer class/struct" },
            ["ic"] = { query = "@class.inner", desc = "Select inner class/struct" },
            -- Параметры
            ["aa"] = { query = "@parameter.outer", desc = "Select outer parameter" },
            ["ia"] = { query = "@parameter.inner", desc = "Select inner parameter" },
            -- Блоки
            ["ab"] = { query = "@block.outer", desc = "Select outer block" },
            ["ib"] = { query = "@block.inner", desc = "Select inner block" },
            -- Условия
            ["ao"] = { query = "@conditional.outer", desc = "Select outer conditional" },
            ["io"] = { query = "@conditional.inner", desc = "Select inner conditional" },
            -- Циклы
            ["al"] = { query = "@loop.outer", desc = "Select outer loop" },
            ["il"] = { query = "@loop.inner", desc = "Select inner loop" },
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = { query = "@function.outer", desc = "Next function start" },
            ["]c"] = { query = "@class.outer", desc = "Next class/struct start" },
            ["]a"] = { query = "@parameter.inner", desc = "Next parameter" },
          },
          goto_next_end = {
            ["]F"] = { query = "@function.outer", desc = "Next function end" },
            ["]C"] = { query = "@class.outer", desc = "Next class/struct end" },
          },
          goto_previous_start = {
            ["[f"] = { query = "@function.outer", desc = "Previous function start" },
            ["[c"] = { query = "@class.outer", desc = "Previous class/struct start" },
            ["[a"] = { query = "@parameter.inner", desc = "Previous parameter" },
          },
          goto_previous_end = {
            ["[F"] = { query = "@function.outer", desc = "Previous function end" },
            ["[C"] = { query = "@class.outer", desc = "Previous class/struct end" },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>sa"] = { query = "@parameter.inner", desc = "Swap with next parameter" },
          },
          swap_previous = {
            ["<leader>sA"] = { query = "@parameter.inner", desc = "Swap with previous parameter" },
          },
        },
      },
    },
  },
}

