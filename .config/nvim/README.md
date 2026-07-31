<div align="center">

# Neovim

</div>

<img src="../../assets/neovim-preview.jpg" alt="Custom Neovim dashboard running in Ghostty" width="100%">

> **Minimal at the core. Powerful at the edges.**
>
> This configuration stays close to native Vim behavior, then layers in the things that make everyday editing faster: intelligent completion, project-wide search, clean buffer management, persistent context, and a fully integrated Git workflow.

- **Native muscle memory** — familiar motions and modes with focused quality-of-life improvements.
- **Fast by default** — plugins load lazily and configuration is split by concern.
- **Quietly intelligent** — LSP, completion, diagnostics, formatting, spelling, and Copilot are there when needed.
- **Visually cohesive** — every major surface is tuned around GitHub Dark Default.

## Features

### Preview Buffers

Opening a file marks it as a temporary preview with a `◌` in the buffer line. Open another file without touching the first and the old preview disappears automatically. This is similar to preview tabs in VS Code.

```text
open file A ◌  →  open file B ◌  →  file A closes
                         │
                         ├── edit or save  →  file B stays
                         └── <leader>bp    →  file B is pinned
```

The result is a buffer list that stays useful instead of becoming a graveyard. The implementation lives in [`lua/plugins/buffers.lua`](./lua/plugins/buffers.lua).

### File context that survives restarts

Cursor position and fold state are saved when a file leaves the window and restored when it returns. Diff views are deliberately excluded so CodeDiff can manage its own layout without interference.

### An interface that adapts

- The Snacks picker switches between wide and vertical layouts based on available width.
- The statusline collapses gracefully in narrow windows.
- Tree-sitter folds, context, and rainbow delimiters share a consistent visual language.
- Notifications, diagnostics, pickers, Git views, and floating windows use custom theme overrides.

## Daily controls

`<leader>` is <kbd>Space</kbd>. Plugin-specific mappings live beside their implementations in [`lua/plugins`](./lua/plugins); global mappings live in [`lua/config/keymaps.lua`](./lua/config/keymaps.lua).

| Area | Key | Action |
| --- | --- | --- |
| Mode | `jk` or `esc` | Leave insert mode |
| Files | `Ctrl+P` | Smart project picker |
| Text | `<leader>pw` | Search text across the project |
| Explorer | `<leader>e` / `<leader>E` | Open Mini Files at the working directory / current file |
| Explorer | `-` | Open the parent directory with Oil |
| Buffers | `<leader>bp` / `<leader>bd` | Pin or close the current buffer |
| Buffers | `Ctrl+1` … `Ctrl+5` | Jump directly to a buffer |
| Editing | `<leader>f` | Format the file or selection |
| Editing | `<leader>p` | Paste over a selection without replacing the register |
| Windows | `<leader>s` / `<leader>S` | Open a vertical / horizontal split |
| Windows | `Ctrl` + `h` `j` `k` `l` | Move between splits |
| Git | `<leader>gg` / `<leader>gG` | Open Neogit / Lazygit |
| Git | `<leader>gh` | Preview the current Git hunk |
| Diagnostics | `X` / `<leader>xx` | Inspect the current line / project diagnostics |
| Tools | `<leader>tt` / `<leader>u` | Toggle the terminal / undo tree |

Centered scrolling, search-result recentering, movable visual selections, selection-preserving indentation, and black-hole delete mappings are also configured globally.

## Defaults

- System clipboard integration and persistent undo history.
- Relative line numbers, a fixed sign column, and ten lines of scroll context.
- Smart-case searching and centered search navigation.
- Tree-sitter-powered folds that start open and persist per file.
- Right-opening vertical splits and below-opening horizontal splits.
- No swap files, backup files, line wrapping, or redundant mode display.
- Hyphenated identifiers are treated as complete words.
- True-color rendering and a blinking cursor that makes stalled SSH sessions obvious.

## Plugin map

Plugins are managed by [lazy.nvim](https://github.com/folke/lazy.nvim) and grouped by responsibility rather than loaded from one giant file.

| Area | Stack |
| --- | --- |
| Language intelligence | [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) · [Mason](https://github.com/mason-org/mason.nvim) · [blink.cmp](https://github.com/Saghen/blink.cmp) · [LuaSnip](https://github.com/L3MON4D3/LuaSnip) |
| AI suggestions | [copilot.lua](https://github.com/zbirenbaum/copilot.lua) |
| Formatting and linting | [conform.nvim](https://github.com/stevearc/conform.nvim) · [nvim-lint](https://github.com/mfussenegger/nvim-lint) · cspell |
| Syntax and folds | [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) · [Treesitter Context](https://github.com/nvim-treesitter/nvim-treesitter-context) · [nvim-ufo](https://github.com/kevinhwang91/nvim-ufo) |
| Search and navigation | [Snacks picker](https://github.com/folke/snacks.nvim) · [Mini Files](https://github.com/nvim-mini/mini.files) · [Oil](https://github.com/stevearc/oil.nvim) |
| Git | [Gitsigns](https://github.com/lewis6991/gitsigns.nvim) · [Neogit](https://github.com/NeogitOrg/neogit) · [CodeDiff](https://github.com/esmuellert/codediff.nvim) · [Snacks Lazygit](https://github.com/folke/snacks.nvim/blob/main/docs/lazygit.md) |
| Interface | [GitHub theme](https://github.com/projekt0n/github-nvim-theme) · [barbar.nvim](https://github.com/romgrk/barbar.nvim) · [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) · [Noice](https://github.com/folke/noice.nvim) |
| Diagnostics | [Trouble](https://github.com/folke/trouble.nvim) · [nvim-scrollbar](https://github.com/petertriho/nvim-scrollbar) · cspell filtering |
| Editing | [mini.pairs](https://github.com/nvim-mini/mini.pairs) · [mini.surround](https://github.com/nvim-mini/mini.surround) · [mini.splitjoin](https://github.com/nvim-mini/mini.splitjoin) · [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) |
| Extras | [which-key](https://github.com/folke/which-key.nvim) · [todo-comments](https://github.com/folke/todo-comments.nvim) · [undotree](https://github.com/mbbill/undotree) · [rainbow-delimiters](https://github.com/hiphish/rainbow-delimiters.nvim) |

## First launch

The main [bootstrap script](../../scripts/bootstrap.sh) installs Neovim and links this configuration with GNU Stow:

```bash
cd ~/.dotfiles
./scripts/bootstrap.sh
nvim
```

On first launch, Neovim bootstraps lazy.nvim, installs the plugin graph, downloads the configured Tree-sitter parsers, and provisions Lua tooling through Mason.

> [!NOTE]
> A Nerd Font is strongly recommended. The configuration uses icons throughout the buffer line, statusline, pickers, diagnostics, and file explorers.

Useful maintenance commands:

| Command | Purpose |
| --- | --- |
| `:Lazy` | Inspect, update, profile, or clean plugins |
| `:Mason` | Inspect installed language servers and tools |
| `:TSUpdate` | Update Tree-sitter parsers |
| `:checkhealth` | Check Neovim and provider health |
| `:ConformInfo` | Inspect formatters available to the current buffer |

## Structure

```text
.
├── init.lua
├── lazy-lock.json
└── lua/
    ├── config/
    │   ├── autocmds.lua   # persistent views and editor events
    │   ├── keymaps.lua    # global controls
    │   ├── lazy.lua       # plugin-manager bootstrap
    │   ├── options.lua    # native editor behavior
    │   └── utils.lua      # shared buffer and window helpers
    └── plugins/
        ├── buffers.lua    # preview-buffer lifecycle
        ├── coding.lua     # editing primitives
        ├── explorer.lua   # Mini Files and Oil
        ├── git.lua        # Gitsigns, Neogit, and Lazygit
        ├── lsp.lua        # language servers and Mason
        ├── picker.lua     # project-aware search
        └── ...            # UI, completion, diagnostics, and more
```