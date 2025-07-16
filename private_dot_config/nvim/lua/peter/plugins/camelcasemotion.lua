---@module "lazy"
---@type LazySpec
return {
    {
        -- Potential alternatives are vim-wordmotion or vim-textobj-variable-segment
        "bkad/CamelCaseMotion",
        event = "VeryLazy",
        init = function()
            vim.g.camelcasemotion_key = [[\]]
        end,
    },
}
