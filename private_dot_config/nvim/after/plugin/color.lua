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

-- Call after setting up colorscheme so colorcolumn highlight is cleared
local has_vc, virtcolumn = pcall(require, "virt-column")
if has_vc then
    virtcolumn.setup()
end
