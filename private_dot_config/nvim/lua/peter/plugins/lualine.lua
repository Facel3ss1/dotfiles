vim.opt.showmode = false

-- TODO: Add winbar in nvim 0.8
-- TODO: Add on_click telescope prompts

require("lualine").setup {
    options = {
        globalstatus = true,
        section_separators = { left = "", right = "" },
        component_separators = { left = "|", right = "|" },
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = {
            { "branch", icon = "" },
        },
        lualine_c = {
            {
                "diagnostics",
                symbols = {
                    error = " ",
                    warn = " ",
                    info = " ",
                    hint = " ",
                },
            },
            { "filename", path = 1 },
        },
        lualine_x = {
            function()
                local tabstop = vim.bo.tabstop
                local shiftwidth = vim.fn.shiftwidth()
                local expandtab = vim.bo.expandtab

                if expandtab then
                    return string.format("spaces: %i", shiftwidth)
                elseif shiftwidth == tabstop then
                    return string.format("tabs: %i", shiftwidth)
                else
                    return string.format("tabs/spaces: %i/%i", tabstop, shiftwidth)
                end
            end,
            "encoding",
            {
                "fileformat",
                symbols = {
                    unix = "lf",
                    dos = "crlf",
                    mac = "cr",
                },
            },
            { "filetype", colored = false },
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
    extensions = { "man", "quickfix" },
}
