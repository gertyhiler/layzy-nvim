# Stabilization Pass — апрель 2026

Один проход по конфигу, цель которого — закрыть пять UX-петель, из-за которых
редактор «красивый, но не удобный». Без переписывания стека.

---

## Проблемы

### 1. Тема: runtime truth не совпадал с README и интуицией

**Симптом:** «Вроде Nord, но мозг спотыкается при чтении кода».

**Диагноз:** В `lazy.lua` не был выставлен ни один colorscheme. LazyVim грузил дефолт
— `tokyonight-moon`. Поверх него `highlights.lua` перекрашивал строки, комментарии
и папки в Nord-цвета. Синтаксис (ключевые слова, типы, функции, числа) оставался
tokyonight'овским. README при этом обещал `carbonfox` (который тоже не был выставлен).

Итог: три несогласованных источника цвета. Мозг, натренированный на пять лет
настоящего Nord, получал цветовую смесь и терял паттерны.

**Дополнительная проблема:** `snacks.nvim` в `06-colors.lua` имел
`config = function()` без вызова `require("snacks").setup(opts)`. В lazy.nvim
это заменяет дефолтный config-handler, то есть LazyVim's opts для Snacks
(picker layout, explorer defaults и прочее) не применялись. Snacks работал
на встроенных дефолтах, не на LazyVim-конфиге.

---

### 2. Скрытые и ignored файлы не были видны по умолчанию

**Симптом:** `<leader>ff` не находит `.env`. В дереве надо каждый раз нажимать
`H` и `I` чтобы увидеть dotfiles и gitignored файлы.

**Диагноз:** Snacks picker и explorer по умолчанию скрывают hidden/ignored файлы.
Настройки `hidden = true` / `ignored = true` не были выставлены ни глобально,
ни для отдельных sources.

---

### 3. LSP-навигация: две команды вместо одной

**Симптом:** В VS Code одна команда «перейти к символу» — она сама решает,
показывать references или definition. В nvim нужно знать заранее: `gd` или `gr`.

**Диагноз:** LazyVim выставляет `gd = vim.lsp.buf.definition`, `gr = vim.lsp.buf.references`.
Никакой смарт-логики нет. Пользователь должен помнить два биндинга вместо одного.

**Побочная проблема:** gopls в `13-lsp-go.lua` настроен с богатым набором
`codelenses` (gc_details, generate, govulncheck, tidy и т.д.), но
`codelens.enabled = false` в LazyVim по умолчанию означает, что они никогда
не обновляются и не показываются автоматически.

---

### 4. Отсутствие feedback-петли «до коммита»

**Симптом:** Можно закоммитить файл с LSP-ошибкой, не заметив её в табе.
Pre-commit хук падает — приходится возвращаться.

**Диагноз:** Буферлайн показывал diagnostic indicators, но они были недостаточно
контрастными: не bold, цвет определялся дефолтом темы (tokyonight, не Nord).
Git-статус файла (изменён/добавлен) в табе отсутствовал полностью.

---

### 5. Completion: docs-popup при каждом движении

**Симптом:** Документация из LSP выскакивает сразу при выборе completion item.
Это создаёт визуальный шум при обычном наборе кода.

**Диагноз:** LazyVim blink.cmp дефолт: `documentation.auto_show = true` с
задержкой 200ms. Ghost text тоже потенциально включён (зависит от `vim.g.ai_cmp`).

При этом `07-tailwind-cmp.lua` в конфиге настраивал nvim-cmp — плагин, который
LazyVim v8 автоматически отключает в пользу blink.cmp. Файл был мёртвым кодом.

---

### 6. Spell check не работал совсем

**Симптом:** Ни в коде, ни в prose буферах нет spell-подсветки.

**Диагноз:** В репо не было никакой spell-конфигурации. cspell-lsp, на который
смотрели раньше, помечен как deprecated. nvim spell (`vim.opt.spell`) нигде не
включался. nvim-lint присутствовал (через LazyVim), но cspell как linter не был
зарегистрирован ни для одного filetype.

---

## Что и как решили

### 1. Тема: `gbprod/nord.nvim` как единственный источник правды

**Выбор:** `gbprod/nord.nvim` (не `shaunsingh/nord.nvim`, не `AlexvZyl/nordic.nvim`).
Аргументы: официально нацелен на паритет с VS Code Nord и vim-nord; имеет native
интеграцию с bufferline, blink.cmp, lualine, gitsigns; активно поддерживается.

**Что сделали:**

`lua/plugins/06-colors.lua` — добавлен `{ "LazyVim/LazyVim", opts = { colorscheme = "nord" } }`
(канонический способ установить colorscheme в LazyVim). Добавлен `gbprod/nord.nvim`
с `lazy = false, priority = 1000`:

```lua
opts = {
  errors = { mode = "fg" },       -- ошибки как foreground, не bg-прямоугольник
  search = { theme = "vim" },
  styles = {
    comments = { italic = true },
    bufferline = { current = {}, modified = { italic = true } },
  },
}
```

Snacks-патч (подмена formatter для SnacksExplorerFileDiagnosticError) перенесён
из `config = function()` в `init = function()` с регистрацией через VeryLazy autocmd.
Это исправляет баг: LazyVim's snacks setup() теперь вызывается корректно, все opts
применяются.

`lua/config/palette.lua` — свёрнут до UI-only токенов: git-цвета (Nord Aurora)
и diag-цвета. Строки/комментарии/папки убраны — тема сама их обеспечивает.

`lua/config/highlights.lua` — удалены `STRING_GROUPS` / `COMMENT_GROUPS` и их recoloring.
Остались только:
- `SnacksPickerGitStatus*` (Snacks не берёт их из темы)
- `SnacksExplorerFileDiagnosticError` (undercurl + `fg = Nord11`)
- `DiagnosticError` (`bold = true`) / `DiagnosticWarn` (для контраста в bufferline)
- `GitSigns*` (gutter)

`lua/config/lazy.lua` — `install.colorscheme` обновлён: `{ "nord", "tokyonight", "habamax" }`.

**Результат:** `nvim --headless -c "lua print(vim.g.colors_name)" -c qa` → `nord`.
Цвет строк, комментариев, функций, типов, чисел — Nord без компромиссов.

---

### 2. Hidden/ignored по умолчанию

**Что сделали:** `lua/plugins/20-snacks-ux.lua` — простой opts-патч:

```lua
picker = {
  hidden = true,
  ignored = true,
  sources = {
    files = { hidden = true, ignored = true },
    grep = { hidden = true, ignored = true },
    explorer = { hidden = true, ignored = true },
  },
}
```

`H` и `I` остаются встроенными opt-out тогглами — не трогаем.
Переопределять биндинги для `y` (copy path) и `<C-t>` (terminal in cwd) не нужно —
они уже работают в Snacks по умолчанию, просто не были задокументированы.

---

### 3. Smart gd + codelens

**Что сделали:** `lua/plugins/21-lsp-keymaps.lua` — расширение `nvim-lspconfig` opts:

```lua
-- gd: request references → если есть, открываем picker; иначе definition
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
```

Ключевой механизм: в LazyVim v8, `opts.keys` для nvim-lspconfig — это массив.
`Keys.resolve()` (lazy.nvim) деплицирует по `lhs`, победитель — последний в массиве.
Добавление нового `gd` через `vim.list_extend(opts.keys, { ... })` в `opts = function(_, opts)`
гарантирует, что наш вариант идёт после LazyVim-дефолта и перебивает его.

Дополнительно:
- `opts.codelens = { enabled = true }` — включает авто-рефреш codelens
  (BufEnter/CursorHold/InsertLeave). Gopls codelenses (gc_details, generate, etc.)
  теперь показываются автоматически.
- `<leader>cD` — plain definition fallback для случаев когда smart мешает.
- `<leader>cc` / `<leader>cC` уже были в LazyVim (run/refresh codelens).

**Почему `gr` не трогали:** LazyVim `<leader>xx` = project-wide Trouble,
`<leader>xX` = buffer Trouble — уже правильно. `gr` = references — оставляем.

---

### 4. Bufferline: git + diagnostics

**Что сделали:** `lua/plugins/23-bufferline.lua`:

Nord highlights через `require("nord.plugins.bufferline").akinsho()` — это
официальная Nord-интеграция, генерирует полный highlights table для всех
bufferline групп (active/inactive/selected/modified/diagnostic).

Git-decoration через `name_formatter`:
```lua
opts.options.name_formatter = function(buf)
  local ok, status = pcall(function()
    return vim.b[buf.bufnr].gitsigns_status_dict
  end)
  if ok and status then
    local n = (status.added or 0) + (status.changed or 0) + (status.removed or 0)
    if n > 0 then return buf.name .. " ~" end
  end
end
```

`gitsigns_status_dict` содержит `added`/`changed`/`removed` как количество строк.
`name_formatter` возвращает `nil` для неизменённых файлов → дефолтное имя.
Порядок табов сохраняется (не используем groups/custom_areas).

`DiagnosticError { bold = true }` в `highlights.lua` → bufferline diagnostic indicator
автоматически становится жирным (nord.plugins.bufferline использует hl-группы, не
хардкодит цвета).

---

### 5. blink.cmp: calm completion

**Что сделали:** Удалён `07-tailwind-cmp.lua` (мёртвый nvim-cmp код).
Создан `lua/plugins/24-blink-tailwind.lua`:

```lua
completion = {
  documentation = { auto_show = false },  -- docs только по <C-k>
  ghost_text = { enabled = false },
}
```

Tailwind color swatch в blink.cmp — отложено (нет прямого порта
`tailwindcss-colorizer-cmp` для blink). `nvim-highlight-colors` (уже в конфиге)
красит hex-цвета inline в редакторе — это частично закрывает потребность.

---

### 6. Spell: два уровня

**Что сделали:** `lua/plugins/22-spell.lua`:

**Уровень 1** — vim spell для prose:
```lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "gitcommit", "text", "NeogitCommitMessage" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en,ru"
  end,
})
```

**Уровень 2** — CSpell через nvim-lint (LazyVim уже подключает nvim-lint):
- Allow-list filetypes: `go`, `lua`, `ts/tsx`, `js/jsx`, `json`, `yaml`, `toml`, `md`, `gitcommit`
- Condition: включается только если в дереве выше текущего файла найден
  `cspell.json` / `.cspell.json` / `cspell.config.*`
- cspell CLI ставится через Mason (`ensure_installed`)
- `vim.diagnostic.INFO` severity → не мешает, но виден

**Почему не cspell-lsp:** он помечен deprecated. CSpell CLI живой и официальный;
через nvim-lint он даёт ту же функциональность без deprecated слоя.

**Dogfooding:** `cspell.json` добавлен в корень этого nvim-репо — словарь из
~60 neovim/lazyvim-специфичных слов (snacks, gopls, lazyvim, codex, и т.д.).

---

## Итоговый diff

### Изменены
| Файл | Что изменилось |
|------|---------------|
| `lua/plugins/06-colors.lua` | Nord вместо carbonfox, snacks init-fix |
| `lua/config/palette.lua` | Только UI-токены (git + diag) |
| `lua/config/highlights.lua` | Убран синтаксис-recoloring, добавлен DiagnosticError bold |
| `lua/plugins/19-diagnostics.lua` | mixing_color вычисляется из Normal.bg |
| `lua/config/lazy.lua` | install.colorscheme включает "nord" |
| `README.md` | Тема исправлена, добавлен раздел «Повседневные мелочи» |

### Созданы
| Файл | Назначение |
|------|-----------|
| `lua/plugins/20-snacks-ux.lua` | hidden/ignored по дефолту |
| `lua/plugins/21-lsp-keymaps.lua` | Smart gd, `<leader>cD`, codelens включен |
| `lua/plugins/22-spell.lua` | vim spell + cspell via nvim-lint |
| `lua/plugins/23-bufferline.lua` | Nord highlights + git `~` суффикс |
| `lua/plugins/24-blink-tailwind.lua` | blink.cmp polish |
| `cspell.json` | Проектный словарь для этого репо |

### Удалены
| Файл | Причина |
|------|---------|
| `lua/plugins/07-tailwind-cmp.lua` | Мёртвый код: настраивал nvim-cmp, который LazyVim v8 отключает |

---

## Что намеренно НЕ делали (и почему)

| Решение | Причина |
|---------|---------|
| Full background git tabs (как VS Code) | bufferline groups ломают порядок табов; suffix `~` стабильнее |
| tmux palette sync | Отдельный pass; не мешать сюда |
| Переопределять `y`/`Y`/`<C-t>` в Snacks | Уже работают по дефолту |
| Авто-open Trouble на save | Шум вреднее пользы |
| Расширенные semantic highlights (Keyword/Function/Type) | gbprod/nord.nvim сам покрывает; overrides были бы дрейфом |
| Tailwind swatch в blink.cmp | Нет готового порта; отложено |
| Трогать AI/Go/DAP слои | Ортогональны проблеме и работают |

---

## Ключевые технические решения

### Почему `init` а не `config` для snacks patching

В lazy.nvim, когда spec задаёт `config = function()`, он заменяет дефолтный
config-handler (который вызывает `require(plugin.main).setup(opts)`).
Использование `config = function()` без вызова `setup()` означало, что
LazyVim's merged opts для Snacks никогда не применялись — Snacks работал
с голыми встроенными дефолтами.

Исправление: `init = function()` с `VeryLazy` autocmd для патча. Без `config`
lazy.nvim использует дефолт → `require("snacks").setup(merged_opts)` вызывается.

### Почему `opts = function(_, opts)` для gd override

LazyVim устанавливает LSP keymaps через `opts.keys` в nvim-lspconfig spec.
`Keys.resolve()` деплицирует по `lhs` — последний в массиве побеждает.
`opts = function(_, opts)` получает уже смёрженный opts (с LazyVim's gd),
`vim.list_extend` добавляет наш gd после него → наш побеждает.

### Почему Nord bufferline через `akinsho()` а не hl-группы вручную

`require("nord.plugins.bufferline").akinsho()` генерирует полный highlights table
из Nord palette hardcode. Это работает независимо от того, применена ли
colorscheme в данный момент (нужно только чтобы `require("nord")` был доступен).
При подходе с hl-группами вручную нужно следить за синхронизацией с темой.
