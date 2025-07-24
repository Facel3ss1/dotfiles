local icons = require("peter.lib.icons")

---@module "lazy"
---@type LazySpec
return {
    {
        -- TODO: lsp_status component?
        "nvim-lualine/lualine.nvim",
        event = "VimEnter",
        opts = function()
            return {
                options = {
                    globalstatus = true,
                    section_separators = { left = "", right = "" },
                    component_separators = { left = "|", right = "|" },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = {
                        { "branch", icon = icons.git.branch },
                    },
                    lualine_c = {
                        {
                            "diagnostics",
                            symbols = {
                                hint = icons.diagnostics.HINT .. " ",
                                info = icons.diagnostics.INFO .. " ",
                                warn = icons.diagnostics.WARN .. " ",
                                error = icons.diagnostics.ERROR .. " ",
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
                        "filetype",
                    },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
                extensions = {
                    "fzf",
                    "lazy",
                    "man",
                    "quickfix",
                    "nvim-dap-ui",
                    "oil",
                },
            }
        end,
        config = function(_, opts)
            vim.o.showmode = false
            require("lualine").setup(opts)
        end,
        dependencies = "nvim-tree/nvim-web-devicons",
    },
}
