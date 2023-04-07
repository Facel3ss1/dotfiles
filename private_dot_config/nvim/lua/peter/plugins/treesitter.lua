return {
    -- TODO: nvim-ts-context-commentstring with lua help comments?
    -- TODO: nvim-ts-autotag
    -- TODO: "in comment" e.g. gqic for formatting (nvim-ts-textobjects)
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = "BufReadPost",
        opts = function()
            return {
                ensure_installed = {
                    "bash",
                    "c",
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
                    "lua",
                    "make",
                    "markdown",
                    "markdown_inline",
                    "meson",
                    "ninja",
                    "python",
                    "query",
                    "regex",
                    "rust",
                    "toml",
                    "tsx",
                    "typescript",
                    "vim",
                    "vimdoc",
                    "yaml",
                },
                sync_install = false,
                auto_install = vim.fn.executable("tree-sitter") == 1,
                highlight = {
                    enable = true,
                    disable = { "help" },
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
                playground = {
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
            -- TODO: vim.treesitter.foldexpr()
            -- vim.o.foldmethod = "expr"
            -- vim.o.foldexpr = "nvim_treesitter#foldexpr()"
            -- vim.o.foldenable = false
        end,
    },
    { "nvim-treesitter/nvim-treesitter-context", module = false, event = "BufReadPre", config = true },
    { "RRethy/nvim-treesitter-endwise", event = "InsertEnter" },
}
