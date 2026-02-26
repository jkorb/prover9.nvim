# prover9.nvim

Neovim plugin for Prover9/Mace4 with Tree-sitter parser registration, highlighting queries, and simple run commands.

## Features

- Registers a `prover9` Tree-sitter parser for `nvim-treesitter`
- Filetypes: `prover9` and `mace4`
- Highlight query: `queries/prover9/highlights.scm`
- Commands:
  - `:Prover9Run`
  - `:Mace4Run`
  - `:Prover9Mace4Race` (runs both; stops the other when one returns)

## Install

Example with `lazy.nvim`:

```lua
{
  "jkorbmacher/prover9.nvim",
  opts = {
    -- Optional overrides:
    -- grammar_url = "https://github.com/jkorbmacher/prover9_treesitter",
    -- grammar_branch = "main",
    -- grammar_files = { "src/parser.c" },
  },
}
```

Then install the parser:

```vim
:TSInstall prover9
```

Notes:

- If a sibling repo `../prover9_treesitter` exists next to this plugin, it is used automatically as parser source.
- Otherwise the plugin uses `grammar_url`.

## Requirements

- Neovim with `vim.system` available
- `nvim-treesitter`
- `prover9` and/or `mace4` binaries in your `PATH`
