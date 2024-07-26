local util = require("peter.util")

-- TODO: neogen
-- TODO: nvim-ts-context-commentstring with lua help comments?
-- TODO: nvim-ts-autotag
-- TODO: "in comment" e.g. gqic for formatting (nvim-ts-textobjects)

---@module "lazy"
---@type LazySpec
return {
    {
        "nvim-treesitter/nvim-treesitter",
        version = "*",
        build = ":TSUpdate",
        event = "BufReadPre",
        cmd = { "TSInstall", "TSInstallInfo", "TSUpdate" },
        opts = function()
            return {
                -- See :h treesitter-parsers and :TSInstallInfo to see the parsers that are built in to Neovim.
                ensure_installed = {
                    "c_sharp",
                    "cmake",
                    "comment",
                    "cpp",
                    "css",
                    "diff",
                    "fish",
                    "haskell",
                    "html",
                    "java",
                    "javascript",
                    "jsdoc",
                    "json",
                    "jsonc",
                    "latex",
                    "make",
                    "meson",
                    "ninja",
                    "regex",
                    "rust",
                    "toml",
                    "tsx",
                    "typescript",
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

            -- FIXME: https://github.com/nvim-telescope/telescope.nvim/issues/699
            -- TODO: vim.treesitter.foldexpr() or just use foldexpr = indent as we use treesitter indent already
            -- vim.o.foldmethod = "expr"
            -- vim.o.foldexpr = "nvim_treesitter#foldexpr()"
            -- vim.o.foldenable = false
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        module = false,
        event = "BufReadPre",
        config = true,
        dependencies = { "nvim-treesitter" },
    },
    {
        "RRethy/nvim-treesitter-endwise",
        event = "InsertEnter",
        dependencies = { "nvim-treesitter" },
    },
}
