local ayu = require("ayu")
local colors = require("ayu.colors")
colors.generate(true)

-- TODO: Move overrides to my own function
-- TODO: Make terminal colors the same as ayu theme in Windows Terminal (ayu dark?)
ayu.setup {
    mirage = true,
    overrides = {
        -- TODO: Override LineNr for ts context if we do this
        -- NormalFloat = { bg = colors.panel_bg },
        WinSeparator = { fg = colors.guide_active },

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
        LightBulbFloatWin = { fg = colors.accent },
    },
}

ayu.colorscheme()
