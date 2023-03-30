# Neovim configuration

Uses [lazy.nvim](https://github.com/folke/lazy.nvim) to manage plugins.

## Folder structure

```
nvim
├── init.lua           // Entry point for the configuration. Automatically sourced by Neovim.
└── lua                // Not automatically sourced, but require()'d by `init.lua` and lazy.nvim.
    └── peter          // Contains any utility modules that are used throughout the config.
        ├── config     // Basic config of builtin Neovim functionality.
        └── plugins    // Plugin configuration, loaded by lazy.nvim.
```

## Requirements

Below are the requirements for the plugins in my config. You will need these in
addition to the software you needed to install these dotfiles (`git` etc.).
Running `:checkhealth` can also show you what is needed by the plugins.

| Name | Reason |
|------|--------|
| A [Nerd Font](https://www.nerdfonts.com/) | Required so we can draw fancy icons and shapes. |
| A C Compiler | Needed by [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) to install the parsers. See [here](https://github.com/nvim-treesitter/nvim-treesitter#requirements). |
| [`ripgrep`](https://github.com/BurntSushi/ripgrep) (optional) | Used by [telescope](https://github.com/nvim-telescope/telescope.nvim) and others for fast file searching. |
| [`fd`](https://github.com/sharkdp/fd) (optional) | Used by [telescope-file-browser](https://github.com/nvim-telescope/telescope-file-browser.nvim) for fast folder searching. |
| `make` (optional) | If installed, it will be used to build [telescope-fzf-native](https://github.com/nvim-telescope/telescope-fzf-native.nvim) to make telescope pickers faster. |
| [The Tree-sitter CLI](https://github.com/tree-sitter/tree-sitter/blob/master/cli/README.md) (optional) | If installed, then nvim-treesitter can automatically install parsers for you. |

LSPs and other tools are installed and managed by
[Mason](https://github.com/williamboman/mason.nvim). In general, to install
tools for a language, you will need the package mangager for that language
(e.g. `cargo`, `pip`, `npm`). You can run `:checkhealth mason` to see what
package managers you have installed.
