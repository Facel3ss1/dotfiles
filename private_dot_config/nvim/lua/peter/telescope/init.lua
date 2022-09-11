local M = {}

function M.grep_prompt()
    vim.ui.input({prompt = "Grep Prompt: "}, function(input)
        if input ~= nil then
            require("telescope.builtin").grep_string({search = input})
        end
    end)
end

-- Opens the file browser in the containing folder of the current buffer
function M.file_browser_in_containing_folder()
    require("telescope").extensions.file_browser.file_browser({path = "%:p:h"})
end

return M
