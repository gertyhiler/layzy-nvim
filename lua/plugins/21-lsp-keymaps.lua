--- Smart LSP navigation: gd = refs-if-exist, otherwise definition.
--- LazyVim defaults are preserved (gr = references, gd = definition);
--- здесь только точечные дополнения поверх них.

local function smart_goto()
  local params = vim.lsp.util.make_position_params(0, "utf-8")
  vim.lsp.buf_request(0, "textDocument/references", {
    textDocument = params.textDocument,
    position = params.position,
    context = { includeDeclaration = false },
  }, function(err, result)
    if not err and result and #result > 0 then
      Snacks.picker.lsp_references()
    else
      Snacks.picker.lsp_definitions()
    end
  end)
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Включаем авто-обновление code lenses (gopls: gc_details, generate, тесты, vuln)
      opts.codelens = vim.tbl_extend("force", opts.codelens or {}, { enabled = true })

      -- Добавляем в конец ключей — Keys.resolve() берёт последнее определение для lhs,
      -- поэтому наш gd перебивает LazyVim-дефолт.
      opts.keys = opts.keys or {}
      vim.list_extend(opts.keys, {
        -- gd: показать references если есть, иначе перейти к definition
        {
          "gd",
          smart_goto,
          desc = "Goto Refs or Definition (smart)",
          has = "definition",
        },
        -- <leader>cD: чистый definition без smart-логики (когда нужен прямой прыжок)
        {
          "<leader>cD",
          vim.lsp.buf.definition,
          desc = "Goto Definition (plain)",
          has = "definition",
        },
      })
    end,
  },
}
