return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Types stay behind K/hover instead of being painted into the buffer.
      inlay_hints = { enabled = false },
      codelens = { enabled = false },
    },
  },
}
