local M = {}

function M.grep_prompt()
    vim.ui.input({prompt = "Grep Prompt: "}, function(input)
        if input ~= nil then
            require("telescope.builtin").grep_string({search = input})
        end
    end)
end

return M
