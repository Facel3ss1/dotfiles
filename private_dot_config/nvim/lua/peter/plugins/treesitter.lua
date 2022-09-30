require("nvim-treesitter.configs").setup {
    -- TODO: make ensure_installed more conservative and use auto_install
    ensure_installed = "all",
    sync_install = false,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    endwise = {
        enable = true,
    },
    -- TODO: enable indent feature
    -- TODO: folding
}
