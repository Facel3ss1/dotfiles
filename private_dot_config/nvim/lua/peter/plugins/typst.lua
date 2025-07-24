local lib = require("peter.lib")

---@module "lazy"
---@type LazySpec
return {
    {
        "chomosuke/typst-preview.nvim",
        version = "*",
        ft = "typst",
        cmd = {
            "TypstPreview",
            "TypstPreviewFollowCursorToggle",
            "TypstPreviewSyncCursor",
        },
        opts = {
            -- Skip download of tinymist by the plugin, it must be installed manually
            -- websocat will be automatically downloaded by the plugin
            dependencies_bin = {
                ["tinymist"] = "tinymist",
                ["websocat"] = nil,
            },
        },
        config = true,
        cond = lib.is_executable("tinymist"),
    },
}
