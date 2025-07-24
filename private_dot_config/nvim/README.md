# Peter's Neovim Config

This is my config for Neovim 0.11. It uses [lazy.nvim](https://lazy.folke.io/) to manage plugins.

## Folder Structure

```
nvim
├── init.lua           // Entry point for the configuration. Automatically sourced by Neovim.
├── lazy-lock.json     // Lockfile of lazy.nvim plugins.
└── lua                // Not automatically sourced, but require()'d by `init.lua`.
    └── peter          // All of my config is namespaced under `peter` to prevent potential name clashes.
        ├── config     // Configuration of built-in Neovim functionality.
        ├── lib        // Contains functions/modules that are used throughout the config.
        └── plugins    // Plugin configuration, loaded by lazy.nvim.
```

## Installing Plugins and Updating Configuration

When running `nvim` for the first time after applying this configuration, it will bootstrap lazy.nvim using `git clone`, then it will proceed to install all the plugins in the configuration. You should make sure all the [plugin requirements](#plugin-requirements) have been installed before using them.

At the root of this repository, there is a `justfile` containing tasks for managing Neovim's plugins and configuration. You can install [`just`](https://github.com/casey/just) to run these tasks. Running `just` without any arguments will print a list of tasks in the `justfile`.

Running `just restore` will install/update all the plugins so that they match the `lazy-lock.json` lockfile. Running `just clean` will remove any plugins that are no longer in the configuration. You can also manage plugins using the lazy.nvim GUI (`:Lazy`) within Neovim.

When editing files in the chezmoi source directory (`~/.local/share/chezmoi/`), I have configured Neovim to automatically run `chezmoi apply` on save (See `peter/config/chezmoi.lua`). However, to apply the Neovim configuration from the command line, use `just apply`, which applies the Neovim configuration to `~/.config/nvim/` ensuring that files that have been deleted from the chezmoi source directory also get deleted (which `chezmoi apply` doesn't do by default).

## Plugin Requirements

Below are the requirements for the plugins in my config. Running `:checkhealth` can also show you what is needed by the plugins.

| Name | Reason |
|------|--------|
| `git`, `tar`, and `curl` | Used by lazy.nvim and others for fetching and installing plugins and binaries. |
| A [Nerd Font](https://www.nerdfonts.com/) | Required so we can draw fancy icons and shapes. (I like the Nerd Font of [Commit Mono](https://commitmono.com/)) |
| A C Compiler (e.g. `gcc`) and [`tree-sitter`](https://github.com/tree-sitter/tree-sitter) | Needed by [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) to install the parsers. See [their README](https://github.com/nvim-treesitter/nvim-treesitter/blob/main/README.md#requirements) for more. |
| [`fzf`](https://github.com/junegunn/fzf), [`rg`](https://github.com/BurntSushi/ripgrep), and [`fd`](https://github.com/sharkdp/fd) | Used by [fzf-lua](https://github.com/ibhagwan/fzf-lua) and others for fast file searching. |

### LSPs and Language-Specific Tools

LSPs and other tools must be installed before using them with Neovim. In general, to install tools for a language, you will need a package manager for that language (e.g. `cargo`, `uv`, `pnpm`). However, you can use a holistic solution like [`mise`](https://mise.jdx.dev/) or [`nix`](https://nixos.org/) to do tool installation across multiple languages consistently.

Each language is configured to use the LSPs/Tools listed below, and these should be installed in order to get the full editor functionality. At a minimum, you should install the tools for Lua to make editing Neovim's configuration easier.

| Language | Tools |
|----------|-------|
| [Lua](https://www.lua.org/) | [`lua-language-server`](https://github.com/LuaLS/lua-language-server) and [`stylua`](https://github.com/JohnnyMorganz/StyLua) |
| [Rust](https://www.rust-lang.org/) | [`rust-analyzer`](https://github.com/rust-lang/rust-analyzer) and [`rustfmt`](https://github.com/rust-lang/rustfmt) |
| [Python](https://www.python.org/) | [`basedpyright`](https://github.com/DetachHead/basedpyright) and [`ruff`](https://github.com/astral-sh/ruff) |
| [TypeScript](https://www.typescriptlang.org/) (and JavaScript) | [`prettier`](https://prettier.io/) (Note that the `typescript` binary comes with the `tsserver` 'LSP') |
| [Typst](https://typst.app/) | [`tinymist`](https://github.com/Myriad-Dreamin/tinymist) |

Other useful tools to install are:

- [`typos-lsp`](https://github.com/tekumara/typos-lsp), an LSP version of [`typos`](https://github.com/crate-ci/typos) for low false-positive spell checking in source code.
