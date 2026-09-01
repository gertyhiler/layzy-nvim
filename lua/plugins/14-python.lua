-- Python editing: Pyright navigation/types, Ruff diagnostics/formatting and
-- project virtual-environment selection. Formatting stays explicit via
-- <leader>cf, as configured globally for this review-first setup.
vim.g.lazyvim_python_lsp = "pyright"
vim.g.lazyvim_python_ruff = "ruff"

return {
  { import = "lazyvim.plugins.extras.lang.python" },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format" },
      },
    },
  },
}
