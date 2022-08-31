vim.opt.showmode = false

require("lualine").setup {
    options = {
        section_separators = { left = "", right = "" },
        component_separators = { left = "|", right = "|" },
    },
    sections = {
        lualine_a = {"mode"},
        lualine_b = {
            {"branch", icon = ""},
            "diagnostics",
        },
        lualine_c = {
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
    extensions = {"man", "nvim-tree"},
}
