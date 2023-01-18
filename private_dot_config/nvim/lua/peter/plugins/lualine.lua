-- TODO: Add on_click telescope prompts
return {
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = {
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
                    {
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
                        cond = function()
                            -- TODO: gitcommit and NeogitCommitMessage
                            local should_hide = vim.bo.filetype == "help" or vim.bo.buftype == "terminal"
                            return not should_hide
                        end,
                    },
                    "encoding",
                    {
                        "fileformat",
                        symbols = {
                            unix = "lf",
                            dos = "crlf",
                            mac = "cr",
                        },
                        cond = function()
                            return vim.bo.buftype ~= "terminal"
                        end,
                    },
                    { "filetype", colored = false },
                },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
            extensions = { "man", "quickfix" },
        },
        config = function(_, opts)
            vim.o.showmode = false
            require("lualine").setup(opts)
        end,
        dependencies = "kyazdani42/nvim-web-devicons",
    },
}
