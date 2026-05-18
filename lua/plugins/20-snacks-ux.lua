return {
  {
    "snacks.nvim",
    opts = {
      picker = {
        -- Показывать скрытые и gitignored файлы по умолчанию везде.
        -- H и I остаются встроенными opt-out тогглами.
        hidden = true,
        ignored = true,
        sources = {
          files = {
            hidden = true,
            ignored = true,
          },
          grep = {
            hidden = true,
            ignored = true,
          },
          explorer = {
            hidden = true,
            ignored = true,
          },
        },
      },
    },
  },
}
