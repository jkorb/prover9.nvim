# prover9.nvim

Neovim plugin for Prover9/Mace4 with Tree-sitter parser registration, highlighting queries, and simple run commands.

> [!IMPORTANT]
> This repository was generated with AI assistance and should not be represented as solely human-authored work.

## Features

- Registers a `prover9` Tree-sitter parser for `nvim-treesitter`
- Filetypes: `prover9` and `mace4`
- File detection for `.p9`, `.prover9`, `.m4`, `.mace4`, and `.in`
- Highlight query: `queries/prover9/highlights.scm`
- Commands:
  - `:Prover9Run`
  - `:Mace4Run`
  - `:Prover9Mace4Race` (runs both; stops the other when one returns)

## Install

Example with `lazy.nvim` from GitHub:

```lua
{
  "jkorbmacher/prover9.nvim",
  opts = {
    grammar_url = "https://github.com/jkorbmacher/prover9_treesitter",
  },
}
```

Example for local development:

```lua
{
  dir = "/Users/jkorbmacher/Dropbox/Projects/prover9.nvim",
  name = "prover9.nvim",
  opts = {
    grammar_url = "/Users/jkorbmacher/Dropbox/Projects/prover9_treesitter",
  },
}
```

Then install the parser:

```vim
:TSInstall prover9
```

Notes:

- For local testing, set `grammar_url` to your local `prover9_treesitter` path.
- `.in` files are detected as `mace4` when path/content suggests Mace4; otherwise they default to `prover9`.

## Requirements

- Neovim with `vim.system` available
- `nvim-treesitter`
- `prover9` and/or `mace4` binaries in your `PATH`
