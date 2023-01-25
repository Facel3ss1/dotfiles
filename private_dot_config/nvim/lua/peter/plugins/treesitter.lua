return {
    -- TODO: nvim-ts-context-commentstring with lua help comments?
    -- TODO: nvim-ts-autotag
    -- TODO: Incremental selection with <CR> and <BS>
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
                    "help",
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
                    "yaml",
                },
                sync_install = false,
                auto_install = vim.fn.executable("tree-sitter") == 1,
                highlight = {
                    enable = true,
                    disable = { "help" },
                    additional_vim_regex_highlighting = false,
                },
                endwise = {
                    enable = true,
                },
                playground = {
                    enable = true,
                },
                -- TODO: enable indent feature here and for indent-blankline
            }
        end,
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)

            -- vim.o.foldmethod = "expr"
            -- vim.o.foldexpr = "nvim_treesitter#foldexpr()"
            -- vim.o.foldenable = false
        end,
    },
    { "nvim-treesitter/nvim-treesitter-context", module = false, event = "BufReadPre", config = true },
    { "RRethy/nvim-treesitter-endwise", event = "InsertEnter" },
    { "nvim-treesitter/playground", cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" } },
}
