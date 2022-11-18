local augroup = require("peter.au").augroup

local M = {}

local function notify(msg, level)
    vim.notify(msg, level, { title = "packer" })
end

local function confirm(msg)
    return vim.fn.confirm(msg, table.concat({ "&Yes", "&No" }, "\n"), 1) == 1
end

local function auto_compile()
    local autocmd = augroup("PackerAutoCompile", { clear = true })
    autocmd("BufWritePost", {
        pattern = { "*/peter/plugins/*.lua", "*/peter/config/plugins.lua", "*/peter/packer.lua" },
        callback = function()
            for p, _ in pairs(package.loaded) do
                if p:find("^peter.plugins") or p == "peter.config.plugins" or p == "peter.packer" then
                    package.loaded[p] = nil
                end
            end

            require("peter.config.plugins")
            require("packer").compile()
            notify("Refreshed and compiled plugins")
        end,
        desc = "Refresh and compile plugins",
    })
end

-- Returns true if we have bootstrapped packer
local function bootstrap()
    local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
    local did_bootstrap = false

    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        -- TODO: Put this in a :PackerBootstrap command
        if confirm("Download packer and install plugins?") then
            notify("Downloading packer.nvim...")
            local out = vim.fn.system {
                "git",
                "clone",
                "--depth",
                "1",
                "https://github.com/wbthomason/packer.nvim",
                install_path,
            }
            notify(out)

            vim.cmd.packadd { "packer.nvim", bang = true }
            did_bootstrap = true
        end
    else
        vim.cmd.packadd { "packer.nvim", bang = true }
    end

    return did_bootstrap
end

function M.setup(config, fn)
    local did_bootstrap = bootstrap()
    local ok, packer = pcall(require, "packer")
    if not ok then
        return
    end

    auto_compile()
    packer.init(config)
    packer.startup(fn)

    if did_bootstrap then
        packer.sync()
        notify("Once the plugins have installed, please restart the editor")
    end
end

return M
