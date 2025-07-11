local util = require("peter.util")

-- TODO: neogen
-- TODO: nvim-ts-context-commentstring with lua help comments?
-- TODO: nvim-ts-autotag
-- TODO: "in comment" e.g. gqic for formatting (nvim-ts-textobjects)

---@module "lazy"
---@type LazySpec
return {
    {
        -- FIXME: Switch to `main` branch and add version field
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        build = ":TSUpdate",
        event = "BufReadPre",
        cmd = { "TSInstall", "TSInstallInfo", "TSUpdate" },
        opts = function()
            return {
                -- See :h treesitter-parsers and :TSInstallInfo to see the parsers that are built in to Neovim.
                ensure_installed = {
                    "c_sharp",
                    "cmake",
                    "cpp",
                    "css",
                    "diff",
                    "dockerfile",
                    "fish",
                    "git_config",
                    "git_rebase",
                    "gitattributes",
                    "gitcommit",
                    "gitignore",
                    "haskell",
                    "html",
                    "java",
                    "javascript",
                    "jsdoc",
                    "json",
                    "jsonc",
                    "just",
                    -- "kdl",
                    "latex",
                    "make",
                    "meson",
                    "ninja",
                    -- "nix",
                    "powershell",
                    "regex",
                    "rust",
                    "sql",
                    -- "terraform",
                    "toml",
                    "tsx",
                    "typescript",
                    "typst",
                    "xml",
                    "yaml",
                },
                sync_install = false,
                auto_install = util.executable("tree-sitter"),
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<CR>",
                        node_incremental = "<CR>",
                        scope_incremental = false,
                        node_decremental = "<BS>",
                    },
                },
                endwise = {
                    enable = true,
                },
                indent = {
                    enable = true,
                },
            }
        end,
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        version = "*",
        module = false,
        event = "BufReadPre",
        config = true,
        dependencies = { "nvim-treesitter" },
    },
    -- FIXME: This won't work with `main` branch of nvim-treesitter, either replace with fork or remove
    {
        "RRethy/nvim-treesitter-endwise",
        event = "InsertEnter",
        dependencies = { "nvim-treesitter" },
    },
}
