local ok, lualine = pcall(require, "lualine")
if not ok then
    return
end

vim.opt.showmode = false

-- TODO: Add global statusline and winbar in nvim 0.8
-- TODO: Add on_click telescope prompts
lualine.setup {
    options = {
        section_separators = { left = "", right = "" },
        component_separators = { left = "|", right = "|" },
    },
    sections = {
        lualine_a = {"mode"},
        lualine_b = {
            {"branch", icon = ""},
        },
        lualine_c = {
            {
                "diagnostics",
                symbols = {
                    error = " ",
                    warn = " ",
                    info = " ",
                    hint = " "
                },
            },
            {"filename", path = 1},
        },
        lualine_x = {
            "encoding",
            {
                "fileformat",
                symbols = {
                    unix = "lf",
                    dos = "crlf",
                    mac = "cr",
                },
            },
            {"filetype", colored = false},
        },
        lualine_y = {"progress"},
        lualine_z = {"location"},
    },
    extensions = {"man", "quickfix"},
}
