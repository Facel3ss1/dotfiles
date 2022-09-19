local notify = require("notify")

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
