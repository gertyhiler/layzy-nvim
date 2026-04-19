# Neovim + Agentic workflow

LazyVim на базе [LazyVim](https://github.com/LazyVim/LazyVim), заточенный под
agent-agnostic разработку: nvim + свободный tty + CLI-агент живут рядом в tmux,
длинные/параллельные задачи идут вне nvim и переживают его рестарт.

## Запуск сессии

```sh
adev                # сессия = basename($PWD), 3 панели в текущей директории
adev -s myproj      # явное имя сессии
adev -a claude      # другой агент (или переменная AGENT_CMD)
adev -a cursor-agent
```

Макет (по умолчанию):

```
┌──────────────────┬────────────┐
│                  │   agent    │  pane title: "agent"
│      nvim        ├────────────┤
│  (pane "nvim")   │   shell    │  pane title: "shell"
└──────────────────┴────────────┘
```

Агентом по умолчанию считается `codex`. Переопределяется через `$AGENT_CMD`
или флаг `-a`. Если агента нет в PATH, pane останется свободным shell-ом.

## AI keymaps (leader = `<space>`)

| Keys                  | Режим | Что делает                                                     |
| --------------------- | ----- | -------------------------------------------------------------- |
| `<leader>ae`          | v     | **edit** — routed frontend (по умолчанию Avante, fallback one-shot) |
| `<leader>ar`          | v     | **one-shot read** — анализ выделения (профиль read, если задан) |
| `<leader>aa`          | n/v   | **ask** — routed frontend (по умолчанию Avante, fallback tmux pane) |
| `<leader>as`          | v     | **send selection** — только вставить в pane (без Enter)            |
| `<leader>af`          | n     | **attach file** — кинуть `@relpath` в pane (без Enter)             |
| `<leader>ap`          | n     | **focus** — переключиться в pane агента                            |
| `<leader>aA`          | n     | **choose provider** — выбрать активного провайдера                 |
| `<leader>aM`          | n     | **choose mode** — frontend mode (`hybrid` / `legacy`)              |

Команды:

```vim
:AiProvider              " показать активный провайдер
:AiProvider claude       " переключить
:AiExec                  " one-shot exec на текущем range (как <leader>ae)
:AiExecRead              " то же с read-профилем
:AiFrontend              " показать/переключить frontend mode
:AiFrontendToggle        " быстрый toggle hybrid <-> legacy
```

### Ключевая идея

- **Hybrid routing**: `ask/edit` идут через настроенный frontend (по умолчанию Avante для `codex`),
  а при проблемах ACP/Avante автоматически откатываются на текущий tmux/one-shot путь.
- **Legacy mode** (`:AiFrontend legacy`) возвращает старое поведение: `ask -> tmux`, `edit -> one-shot`.
- **Длинные/параллельные задачи** (`<leader>as/af/ap`) всегда остаются в interactive
  TUI агента в соседнем tmux-pane. Можно `:qa!` nvim — агент продолжает работать.
  При возврате в nvim изменения подтягиваются: включён `autoread`, на
  `FocusGained/BufEnter/CursorHold` вызывается `:checktime` (`lua/config/ai/autoreload.lua`).
- **Агностика** — провайдер выбирается в `lua/config/ai/config.lua` или налету
  через `:AiProvider`. Добавить нового — файл в `lua/config/ai/providers/` с полями
  `name`, `cmd`, `oneshot_argv(cwd, opts)`, `file_reference(relpath)`.

## Тема

- Core: `carbonfox` из `EdenEast/nightfox.nvim` (OLED-ориентированный стиль той же семьи).
- Палитра: `lua/config/palette.lua` — `bg = #000000`, с минимальным подъёмом
  `bg_alt = #0a0a0c` / `bg_float = #101014` для иерархии поверхностей.
- Семантика (Function/Keyword/Type/String/Number/GitSigns/Diff) — в `lua/config/highlights.lua`;
  пересаживается автоматически на `ColorScheme`, так что смена темы её не ломает.
- Tmux (`~/.config/tmux/tmux.conf`) использует ту же палитру — pane-border,
  status bar, window-current — синхронно с nvim.

## tmux шпаргалка

Prefix по умолчанию `C-b`. Биндинги сверху дефолта:

| Key         | Действие                                   |
| ----------- | ------------------------------------------ |
| `prefix \|` | split-h (в CWD текущей pane)               |
| `prefix -`  | split-v (в CWD текущей pane)               |
| `prefix c`  | new-window в CWD                           |
| `prefix R`  | reload `~/.config/tmux/tmux.conf`          |
| `prefix h/j/k/l` | переключение между панелями (vim-like)|
| `prefix H/J/K/L` | resize (повторяемый)                  |
| `prefix A`  | задать title текущей pane                  |
| `v / y` в copy-mode | vi-селект + копия в macOS clipboard |

## Структура

```
lua/
├── config/
│   ├── ai/
│   │   ├── init.lua          — setup(): autoreload + config + keymaps
│   │   ├── config.lua        — defaults + runtime state (provider + frontend mode)
│   │   ├── buffer.lua        — range/selection/workspace_root/output
│   │   ├── tmux.lua          — find pane by title, paste, focus
│   │   ├── oneshot.lua       — short edits via vim.system (blocking)
│   │   ├── pane.lua          — long tasks → tmux agent pane
│   │   ├── avante.lua        — Avante adapter + availability checks
│   │   ├── router.lua        — frontend routing + fallback
│   │   ├── keymaps.lua       — <leader>a… карта + :AiProvider/:AiFrontend
│   │   ├── autoreload.lua    — :checktime on focus/enter
│   │   └── providers/
│   │       ├── codex.lua
│   │       ├── claude.lua
│   │       └── cursor_agent.lua
│   ├── palette.lua           — OLED палитра
│   ├── highlights.lua        — семантика поверх темы
│   ├── autocmds.lua          — грузит config.ai.setup()
│   ├── keymaps.lua
│   ├── options.lua
│   └── lazy.lua
└── plugins/
    ├── 06-colors.lua         — carbonfox + overrides
    └── 10-ai.lua             — avante.nvim (ACP codex) + AI frontend integration
```
