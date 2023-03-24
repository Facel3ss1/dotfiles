---@param c string
local function hex_to_rgb(c)
    c = string.lower(c)
    return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
end

---@param c number[]
local function rgb_to_hex(c)
    return string.format("#%02x%02x%02x", c[1], c[2], c[3])
end

---@param foreground string foreground color
---@param background string background color
---@param alpha number|string number between 0 and 1. 0 results in bg, 1 results in fg
local function blend(foreground, background, alpha)
    alpha = type(alpha) == "string" and (tonumber(alpha, 16) / 0xff) or alpha
    local bg = hex_to_rgb(background)
    local fg = hex_to_rgb(foreground)

    local function blend_channel(i)
        local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
        return math.floor(math.min(math.max(0, ret), 255) + 0.5)
    end

    return rgb_to_hex { blend_channel(1), blend_channel(2), blend_channel(3) }
end

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
                    -- NormalFloat = { bg = colors.panel_bg },
                    -- Turn off italics in comments
                    Comment = { fg = colors.comment },
                    -- Workaround for https://github.com/neovim/neovim/issues/9800
                    CursorLine = { bg = colors.line, ctermfg = 15 },
                    WinSeparator = { fg = colors.guide_active, bg = colors.line },
                    LspCodeLens = { fg = colors.comment, italic = true },
                    LspCodeLensSeparator = { fg = colors.comment },

                    Todo = { link = "DiagnosticInfo" },

                    -- Add faded background for diagnostics virtual text
                    DiagnosticVirtualTextError = { fg = colors.error, bg = blend(colors.error, colors.bg, 0.1) },
                    DiagnosticVirtualTextWarn = { fg = colors.keyword, bg = blend(colors.keyword, colors.bg, 0.1) },
                    DiagnosticVirtualTextInfo = { fg = colors.tag, bg = blend(colors.tag, colors.bg, 0.1) },
                    DiagnosticVirtualTextHint = { fg = colors.regexp, bg = blend(colors.regexp, colors.bg, 0.1) },

                    -- nvim-notify
                    NotifyTRACETitle = { fg = colors.comment },
                    NotifyDEBUGTitle = { link = "DiagnosticFloatingHint" },
                    NotifyINFOTitle = { link = "DiagnosticFloatingInfo" },
                    NotifyWARNTitle = { link = "DiagnosticFloatingWarn" },
                    NotifyERRORTitle = { link = "DiagnosticFloatingError" },

                    NotifyTRACEIcon = { fg = colors.comment },
                    NotifyDEBUGIcon = { link = "DiagnosticFloatingHint" },
                    NotifyINFOIcon = { link = "DiagnosticFloatingInfo" },
                    NotifyWARNIcon = { link = "DiagnosticFloatingWarn" },
                    NotifyERRORIcon = { link = "DiagnosticFloatingError" },

                    NotifyTRACEBorder = { fg = colors.comment },
                    NotifyDEBUGBorder = { link = "DiagnosticFloatingHint" },
                    NotifyINFOBorder = { link = "DiagnosticFloatingInfo" },
                    NotifyWARNBorder = { link = "DiagnosticFloatingWarn" },
                    NotifyERRORBorder = { link = "DiagnosticFloatingError" },

                    -- fidget
                    FidgetTitle = { fg = colors.func },
                    FidgetTask = { fg = colors.comment },

                    -- nvim-lightbulb
                    LightBulbSign = { fg = colors.accent },

                    -- nvim-treesitter-context
                    TreesitterContext = { bg = colors.panel_bg },
                    TreesitterContextLineNumber = { fg = colors.guide_normal, bg = colors.panel_bg },
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
