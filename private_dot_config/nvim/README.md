# Neovim configuration

Uses [lazy.nvim](https://github.com/folke/lazy.nvim) to manage plugins.

## Folder structure

```
nvim
├── init.lua           // Entry point for the configuration. Automatically sourced by Neovim.
└── lua                // Not automatically sourced, but require()'d by `init.lua` and lazy.nvim.
    └── peter          // All of my config is namespaced under `peter` to prevent potential name clashes.
        ├── config     // Configuration of built-in Neovim functionality.
        ├── plugins    // Plugin configuration, loaded by lazy.nvim.
        └── util       // Contains any utility functions/modules that are used throughout the config.
```

## Requirements

Below are the requirements for the plugins in my config. Running `:checkhealth`
can also show you what is needed by the plugins.

| Name | Reason |
|------|--------|
| `git`, `tar`, and `curl` | Used by lazy.nvim and others for fetching and installing plugins and binaries. |
| A [Nerd Font](https://www.nerdfonts.com/) | Required so we can draw fancy icons and shapes. (I like the Nerd Font of [Commit Mono](https://commitmono.com/)) |
| A C Compiler (e.g. `gcc`) and [`tree-sitter`](https://github.com/tree-sitter/tree-sitter) | Needed by [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) to install the parsers. See [here](https://github.com/nvim-treesitter/nvim-treesitter/blob/main/README.md#requirements). |
| [`ripgrep`](https://github.com/BurntSushi/ripgrep) (optional) | Used by [telescope](https://github.com/nvim-telescope/telescope.nvim) and others for fast file searching. |
| `make` (optional) | If installed, it will be used to build [telescope-fzf-native](https://github.com/nvim-telescope/telescope-fzf-native.nvim) to make telescope pickers faster. |

### Language LSPs and Tools

LSPs and other tools must be installed before using them with Neovim. In
general, to install tools for a language, you will need a package manager for
that language (e.g. `cargo`, `uv`, `pnpm`). Ideally, you'd use a holistic
solution like [`mise`](https://mise.jdx.dev/) or [`nix`](https://nixos.org/) to
do tool installation consistently.

Each language is configured to use the LSPs/Tools listed below, and these
should be installed in order to get the full editor functionality. At a
minimum, you should install the tools for Lua to make editing Neovim's
configuration easier.

| Language | Tools |
|----------|-------|
| [Lua](https://www.lua.org/) | [`lua-language-server`](https://github.com/LuaLS/lua-language-server) and [`stylua`](https://github.com/JohnnyMorganz/StyLua) |
| [Rust](https://www.rust-lang.org/) | [`rust-analyzer`](https://github.com/rust-lang/rust-analyzer) |
| [Python](https://www.python.org/) | [`basedpyright`](https://github.com/DetachHead/basedpyright) and [`ruff`](https://github.com/astral-sh/ruff) |
| [TypeScript](https://www.typescriptlang.org/) (and JavaScript) | [`prettier`](https://prettier.io/) (Note that the `typescript` binary comes with the `tsserver` 'LSP') |
| [Typst](https://typst.app/) | [`tinymist`](https://github.com/Myriad-Dreamin/tinymist) |

Other useful tools to install are:

- [`typos-lsp`](https://github.com/tekumara/typos-lsp) for low false-positive spell checking in source code
