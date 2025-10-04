return {
  -- Mason инструменты для веб-разработки
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "eslint-lsp",
        "css-lsp",
        "html-lsp",
        "prettier",
        "eslint_d",
      })
    end,
  },
} 