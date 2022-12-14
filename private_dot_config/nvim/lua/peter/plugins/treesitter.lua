require("nvim-treesitter.configs").setup {
    ensure_installed = {
        "bash",
        "c",
        "c_sharp",
        "cmake",
        "comment",
        "cpp",
        "css",
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
        "sql",
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
    -- TODO: enable indent feature
    -- TODO: folding
}
