return {
    {
        "Shatur/neovim-ayu",
        lazy = false,
        priority = 1000,
        opts = function()
            local colors = require("ayu.colors")
            colors.generate(true)

            -- TODO: Make terminal colors the same as ayu theme in Windows Terminal (ayu dark?)
            return {
                mirage = true,
                overrides = {
                    -- TODO: Override LineNr for ts context if we do this
                    -- NormalFloat = { bg = colors.panel_bg },
                    Comment = { fg = colors.comment },
                    WinSeparator = { fg = colors.guide_active, bg = colors.line },

                    -- nvim-notify
                    NotifyTRACETitle = { fg = colors.comment },
                    NotifyDEBUGTitle = { link = "DiagnosticHint" },
                    NotifyINFOTitle = { link = "DiagnosticInfo" },
                    NotifyWARNTitle = { link = "DiagnosticWarn" },
                    NotifyERRORTitle = { link = "DiagnosticError" },

                    NotifyTRACEIcon = { fg = colors.comment },
                    NotifyDEBUGIcon = { link = "DiagnosticHint" },
                    NotifyINFOIcon = { link = "DiagnosticInfo" },
                    NotifyWARNIcon = { link = "DiagnosticWarn" },
                    NotifyERRORIcon = { link = "DiagnosticError" },

                    NotifyTRACEBorder = { fg = colors.comment },
                    NotifyDEBUGBorder = { link = "DiagnosticHint" },
                    NotifyINFOBorder = { link = "DiagnosticInfo" },
                    NotifyWARNBorder = { link = "DiagnosticWarn" },
                    NotifyERRORBorder = { link = "DiagnosticError" },

                    -- fidget
                    FidgetTitle = { fg = colors.func },
                    FidgetTask = { fg = colors.comment },

                    -- nvim-lightbulb
                    LightBulbSign = { fg = colors.accent },
                },
            }
        end,
        config = function(_, opts)
            local ayu = require("ayu")
            ayu.setup(opts)
            ayu.colorscheme()
        end,
    },
}
