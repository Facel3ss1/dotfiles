local ok, ayu = pcall(require, "ayu")
if not ok then
    return
end

local colors = require("ayu.colors")
colors.generate(true)

ayu.setup {
    mirage = true,
    overrides = {
        -- nvim-notify
        NotifyDEBUGTitle = { fg = colors.comment },
        NotifyTRACETitle = { fg = colors.entity },
        NotifyINFOTitle = { fg = colors.string },
        NotifyWARNTitle = { fg = colors.warning },
        NotifyERRORTitle = { fg = colors.error },

        NotifyDEBUGIcon = { fg = colors.comment },
        NotifyTRACEIcon = { fg = colors.entity },
        NotifyINFOIcon = { fg = colors.string },
        NotifyWARNIcon = { fg = colors.warning },
        NotifyERRORIcon = { fg = colors.error },

        NotifyDEBUGBorder = { fg = colors.comment },
        NotifyTRACEBorder = { fg = colors.entity },
        NotifyINFOBorder = { fg = colors.string },
        NotifyWARNBorder = { fg = colors.warning },
        NotifyERRORBorder = { fg = colors.error },
    },
}

ayu.colorscheme()

-- Configure colors after setting up color scheme
local has_vc, virt_column = pcall(require, "virt-column")
if has_vc then
    virt_column.setup()
end

local has_notify, notify = pcall(require, "notify")
if has_notify then
    notify.setup {
        stages = "fade",
        top_down = false,
        icons = {
            DEBUG = "",
            ERROR = "",
            INFO = "",
            TRACE = "",
            WARN = "",
        },
    }
    vim.notify = notify
end
