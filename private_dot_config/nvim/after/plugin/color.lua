local ok, ayu = pcall(require, "ayu")
if not ok then
    return
end

ayu.setup {
    mirage = true,
    overrides = {
        Normal = { bg = "none" },
        SignColumn = { bg = "none" },
    },
}

ayu.colorscheme()
