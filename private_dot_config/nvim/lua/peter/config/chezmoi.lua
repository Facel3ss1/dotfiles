local M = {}

local util = require("peter.util")

M.source_dir = vim.fs.normalize("~/.local/share/chezmoi")

-- TODO: Keymap to jump to target path file
-- TODO: Use vim.filetype.add() to register filetypes

---Runs `chezmoi {args}` and notifies the user with `success_message` if successful.
---
---If the command fails, the user is notified with the stderr output.
---@param args string[]
---@param success_message string
local function chezmoi(args, success_message)
    vim.system({ "chezmoi", unpack(args) }, { text = true }, function(out)
        if out.code == 0 then
            util.info(success_message, { title = "chezmoi" })
        else
            -- Trim trailing \n from stderr
            util.warn(out.stderr:gsub("%s+$", ""), { title = "chezmoi" })
        end
    end)
end

-- Automatically run `chezmoi apply` on save for files in the source state
vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("peter.chezmoi.apply", { clear = true }),
    pattern = M.source_dir .. "/*",
    callback = function(opts)
        -- TODO: Exclude certain filetypes?
        -- TODO: Somehow check the output of `chezmoi ignored`? Seems difficult
        -- NOTE: See https://github.com/alker0/chezmoi.vim

        -- The absolute path of the current buffer
        local absolute_path = opts.match
        -- Ignore paths that are in the .git folder
        -- Note that we need to escape the dots in the path
        local git_folder_pattern = M.source_dir:gsub("%.", "%%.") .. "/%.git/.*"
        if absolute_path:match(git_folder_pattern) then
            return
        end

        local relative_path = vim.fn.expand("%")
        chezmoi({ "apply", "--source-path", relative_path }, "chezmoi apply: " .. relative_path)
    end,
    desc = "Run chezmoi apply",
})

-- Run `chezmoi add lazy-lock.json` whenever a plugin is installed, updated, or removed
-- On Windows, this will only work in WSL
if not util.has("win32") then
    vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("peter.chezmoi.add_lazy_lock", { clear = true }),
        pattern = { "LazyInstall", "LazyUpdate", "LazyClean" },
        callback = function()
            local lockfile = vim.fs.normalize(vim.fn.stdpath("config") .. "/lazy-lock.json")
            chezmoi({ "add", lockfile }, "chezmoi add: lazy-lock.json")
        end,
        desc = "Run chezmoi add lazy-lock.json",
    })
end

return M
