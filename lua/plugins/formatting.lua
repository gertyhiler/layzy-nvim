return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        html = { "prettier" },
        markdown = { "prettier" },
        lua = { "stylua" },
        fish = { "fish_indent" },
        sh = { "shfmt" },
        -- Go форматирование
        go = { "goimports", "gofumpt" },
        gomod = { "gofumpt" },
        gowork = { "gofumpt" },
      },
      formatters = {
        prettier = {
          condition = function(self, ctx)
            return vim.fs.find({ "prettier.config.cjs", ".prettierrc", ".prettierrc.json" }, { path = ctx.filename, upward = true })[1]
          end,
        },
      },
    },
  },
}