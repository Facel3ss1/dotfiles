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

Below are the requirements for the plugins in my config. You will need these in
addition to the software you needed to install these dotfiles (`git` etc.).
Running `:checkhealth` can also show you what is needed by the plugins.

| Name | Reason |
|------|--------|
| A [Nerd Font](https://www.nerdfonts.com/) | Required so we can draw fancy icons and shapes. (I like the Nerd Font of [Commit Mono](https://commitmono.com/)) |
| A C Compiler | Needed by [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) to install the parsers. See [here](https://github.com/nvim-treesitter/nvim-treesitter#requirements). |
| [`ripgrep`](https://github.com/BurntSushi/ripgrep) (optional) | Used by [telescope](https://github.com/nvim-telescope/telescope.nvim) and others for fast file searching. |
| `make` (optional) | If installed, it will be used to build [telescope-fzf-native](https://github.com/nvim-telescope/telescope-fzf-native.nvim) to make telescope pickers faster. |

### Language LSPs and Tools

LSPs and other tools are installed and managed by
[Mason](https://github.com/williamboman/mason.nvim). In general, to install
tools for a language, you will need a package manager for that language (e.g.
`cargo`, `uv`, `pnpm`). You can run `:checkhealth mason` to see what package
managers you have installed.

Each language is configured to use the LSPs/Tools listed below, and these
should be installed in order to get the full editor functionality:

| Language | Tools |
|----------|-------|
| [Typst](https://typst.app/) | [`tinymist`](https://github.com/Myriad-Dreamin/tinymist) and [`websocat`](https://github.com/vi/websocat) for [typst-preview](https://github.com/chomosuke/typst-preview.nvim)
