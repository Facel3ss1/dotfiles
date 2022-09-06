local ok = pcall(require, "nvim-treesitter")
if not ok then
    return
end

require("nvim-treesitter.configs").setup {
    ensure_installed = "all",
    sync_install = false,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}
