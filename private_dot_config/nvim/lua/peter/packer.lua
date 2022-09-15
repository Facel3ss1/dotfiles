local M = {}

-- Returns true if we have bootstrapped packer
local function bootstrap()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
    local did_bootstrap = false

    if fn.empty(fn.glob(install_path)) > 0 then
        vim.ui.input({prompt = "Download packer and install plugins? (y/n): "}, function(input)
            if input == "y" then
                print("Downloading packer.nvim...")
                local out = fn.system({"git", "clone", "https://github.com/wbthomason/packer.nvim", install_path})
                print(out)

                vim.cmd("packadd packer.nvim")
                did_bootstrap = true
            end
        end)
    else
        vim.cmd("packadd packer.nvim")
    end

    return did_bootstrap
end

function M.setup(config, fn)
    local did_bootstrap = bootstrap()
    local ok, packer = pcall(require, "packer")

    if ok then
        packer.init(config)
        packer.startup(fn)

        if did_bootstrap then
            packer.sync()
            print("Once the plugins have installed, please restart the editor")
        end
    end
end

return M
