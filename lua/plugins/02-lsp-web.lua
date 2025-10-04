return {
  -- Дополнительные LSP серверы для веб-разработки
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- ESLint для линтинга
        eslint = {
          settings = {
            workingDirectory = { mode = "auto" },
          },
        },
        -- CSS LSP
        cssls = {},
        -- SCSS LSP
        scss = {},
        -- HTML LSP
        html = {},
        -- Tailwind CSS LSP
        tailwindcss = {
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  "cva\\(([^)]*)\\)",
                  "[\"'`]([^\"'`]*).*?[\"'`]",
                },
              },
            },
          },
        },
      },
    },
  },
} 