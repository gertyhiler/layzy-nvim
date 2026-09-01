# Neovim review workspace

LazyVim configuration for reading code and reviewing changes next to external
tools in Herdr. Neovim does not start or control an agent: Codex edits the
working tree, Hunk presents the diff, and Neovim provides project structure,
LSP navigation, diagnostics, TODOs and clipboard-ready context.

## Workflow

```text
Codex ──writes──> working tree <──reads── Neovim
                         │
                         └────────reads── Hunk

Neovim ──OSC 52──> clipboard of the local Herdr client ──paste──> Codex
```

Files changed outside Neovim are reloaded on focus and buffer events. Project
commands such as `setup`, `check`, `format`, `test`, `dev` and `build` belong in
each project's Makefile rather than in editor-specific mappings.

## Core actions

Leader is `<space>`.

### Agent context

| Keys | Mode | Action |
| --- | --- | --- |
| `<leader>y` | visual | Copy selected code to the local clipboard |
| `<leader>yf` | normal | Copy the current path relative to the Git root |
| `<leader>yr` | normal/visual | Copy `path:line` or `path:first-last` |
| `<leader>yc` | normal/visual | Copy a file reference and fenced code block |

The unnamed Vim register remains local. Explicit context yanks use OSC 52, so
they work through `herdr --remote` without NeoClip, tmux or a remote clipboard
program. Paste into the remote session with the Herdr/client paste action.

### Review and navigation

| Keys | Action |
| --- | --- |
| `]h` / `[h` | Next / previous Git hunk |
| `<leader>ghp` | Preview current hunk inline |
| `<leader>ghd` | Diff current file |
| `gd` | References when present, otherwise definition |
| `gr` | References |
| `gI` | Implementation |
| `gy` | Type definition |
| `K` | Hover, including type information |
| `<leader>xx` | Project diagnostics |
| `<leader>xX` | Current-buffer diagnostics |

LSP inlay hints and code lenses are disabled. TypeScript, Go and Python
language support are enabled. Python uses Pyright for navigation and type
information, Ruff for diagnostics and explicit formatting, and supports
project virtual-environment selection with `<leader>cv`.

### TODO and formatting

| Keys | Action |
| --- | --- |
| `<leader>td` | Insert an indented `TODO:` comment below and start typing |
| `]t` / `[t` | Next / previous TODO comment |
| `<leader>st` | Search project TODO comments |
| `<leader>cf` | Format the buffer or visual selection explicitly |

Formatting on save is disabled globally.

## Clipboard model

- `y`, `p` and the unnamed register stay inside Neovim.
- `<leader>y...` writes to the host clipboard through OSC 52.
- Clipboard history is intentionally not persisted.
- Reading the host clipboard through OSC 52 is not required; use the normal
  Herdr/client paste action instead.

## Language and review tooling

- LazyVim, Snacks picker/explorer and Treesitter
- TypeScript/JavaScript, Go and Python LSP support
- Gitsigns and Trouble
- Todo Comments
- Conform, invoked manually with `<leader>cf`
- prose spellcheck and project-scoped CSpell

There is intentionally no embedded AI frontend, agent provider/router, DAP,
remote-nvim, NeoClip or Go command suite in this configuration.
