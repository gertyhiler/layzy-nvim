return {
  -- Тема Nord (gbprod версия)
  -- https://github.com/gbprod/nord.nvim
  {
    "gbprod/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nord").setup({
        transparent = false,
        terminal_colors = true,
        diff = { mode = "bg" },
        borders = true,
        errors = { mode = "bg" },
        styles = {
          comments = { italic = true },
          keywords = { italic = false },
          functions = {},
          variables = {},
        },

        -- === ПЕРЕОПРЕДЕЛЕНИЯ ПОД VSCODE ===
        on_highlights = function(hl, c)
          -- Цвета Nord
          local nord = {
            bg = "#2E3440",
            bg_light = "#3B4252",
            bg_lighter = "#434C5E",
            fg = "#D8DEE9",
            fg_light = "#E5E9F0",
            fg_bright = "#ECEFF4",
            teal = "#8FBCBB",
            cyan = "#88C0D0",
            blue = "#81A1C1",
            dark_blue = "#5E81AC",
            red = "#BF616A",
            orange = "#D08770",
            yellow = "#EBCB8B",
            green = "#A3BE8C",
            purple = "#B48EAD",
          }

          -- VSCode specific
          local vscode = {
            comment = "#638E76", -- зеленоватые комментарии
            git_modified = "#E2C08D", -- жёлтый
            git_added = "#89D185", -- зелёный
            git_deleted = "#F14C4C", -- красный
            git_ignored = "#8C8C8C", -- серый
            folder_icon = "#E8AB53", -- иконка папки
          }

          -- =====================
          -- 1. КОММЕНТАРИИ (зеленоватые как в VSCode)
          -- =====================
          hl["Comment"] = { fg = vscode.comment, italic = true }
          hl["@comment"] = { fg = vscode.comment, italic = true }

          -- =====================
          -- 2. ФУНКЦИИ (cyan)
          -- =====================
          hl["@function"] = { fg = nord.cyan }
          hl["@function.call"] = { fg = nord.cyan }
          hl["@function.builtin"] = { fg = nord.cyan }
          hl["@function.method"] = { fg = nord.cyan }
          hl["@function.method.call"] = { fg = nord.cyan }
          hl["@lsp.type.function"] = { fg = nord.cyan }
          hl["@lsp.type.method"] = { fg = nord.cyan }

          -- =====================
          -- 3. КЛЮЧЕВЫЕ СЛОВА (blue)
          -- =====================
          hl["@keyword"] = { fg = nord.blue }
          hl["@keyword.function"] = { fg = nord.blue }
          hl["@keyword.return"] = { fg = nord.blue }

          -- =====================
          -- 4. ТИПЫ (teal)
          -- =====================
          hl["@type"] = { fg = nord.teal }
          hl["@type.builtin"] = { fg = nord.teal }
          hl["@lsp.type.class"] = { fg = nord.teal }
          hl["@lsp.type.interface"] = { fg = nord.teal }

          -- =====================
          -- 5. СТРОКИ (green)
          -- =====================
          hl["@string"] = { fg = nord.green }
          hl["String"] = { fg = nord.green }

          -- =====================
          -- 6. ЧИСЛА (purple)
          -- =====================
          hl["@number"] = { fg = nord.purple }
          hl["@number.float"] = { fg = nord.purple }

          -- =====================
          -- 7. ПЕРЕМЕННЫЕ И СВОЙСТВА (белые)
          -- =====================
          hl["@variable"] = { fg = nord.fg }
          hl["@variable.member"] = { fg = nord.fg }
          hl["@property"] = { fg = nord.fg }
          hl["@field"] = { fg = nord.fg }

          -- =====================
          -- 8. ПУНКТУАЦИЯ (светлая)
          -- =====================
          hl["@punctuation"] = { fg = nord.fg_bright }
          hl["@punctuation.bracket"] = { fg = nord.fg_bright }
          hl["@punctuation.delimiter"] = { fg = nord.fg_bright }

          -- =====================
          -- 9. NEO-TREE / FILE EXPLORER
          -- =====================
          -- Фон такой же как у редактора
          hl["NeoTreeNormal"] = { fg = nord.fg, bg = nord.bg }
          hl["NeoTreeNormalNC"] = { fg = nord.fg, bg = nord.bg }
          hl["NeoTreeEndOfBuffer"] = { fg = nord.bg, bg = nord.bg }

          -- Папки и файлы - ВСЕ БЕЛЫЕ
          hl["Directory"] = { fg = nord.fg }
          hl["NeoTreeDirectoryName"] = { fg = nord.fg }
          hl["NeoTreeDirectoryIcon"] = { fg = vscode.folder_icon }
          hl["NeoTreeFileName"] = { fg = nord.fg }
          hl["NeoTreeRootName"] = { fg = nord.fg, bold = true }

          -- Открытые папки - тоже белые (не cyan!)
          hl["NeoTreeOpenedFolderName"] = { fg = nord.fg }

          -- Git статусы
          hl["NeoTreeGitModified"] = { fg = vscode.git_modified }
          hl["NeoTreeGitUnstaged"] = { fg = vscode.git_modified }
          hl["NeoTreeGitAdded"] = { fg = vscode.git_added }
          hl["NeoTreeGitUntracked"] = { fg = vscode.git_added }
          hl["NeoTreeGitStaged"] = { fg = vscode.git_added }
          hl["NeoTreeGitDeleted"] = { fg = vscode.git_deleted, strikethrough = true }
          hl["NeoTreeGitIgnored"] = { fg = vscode.git_ignored }
          hl["NeoTreeGitConflict"] = { fg = vscode.git_deleted }

          -- =====================
          -- 10. GIT SIGNS
          -- =====================
          hl["GitSignsAdd"] = { fg = vscode.git_added }
          hl["GitSignsChange"] = { fg = vscode.git_modified }
          hl["GitSignsDelete"] = { fg = vscode.git_deleted }

          -- =====================
          -- 11. ДИАГНОСТИКА
          -- =====================
          hl["DiagnosticError"] = { fg = nord.red }
          hl["DiagnosticWarn"] = { fg = nord.yellow }
          hl["DiagnosticInfo"] = { fg = nord.cyan }
          hl["DiagnosticHint"] = { fg = nord.dark_blue }
        end,
      })

      vim.cmd.colorscheme("nord")
    end,
  },
  {
    "nickkadutskyi/jb.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      -- require("jb").setup({transparent = true})
      vim.cmd("colorscheme jb")
    end,
  },

  -- Установка colorscheme для LazyVim
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "jb",
    },
  },

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
