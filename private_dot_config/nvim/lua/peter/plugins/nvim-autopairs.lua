---@module "lazy"
---@type LazySpec
return {
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function(_, opts)
            local nvim_autopairs = require("nvim-autopairs")
            nvim_autopairs.setup(opts)

            local Rule = require("nvim-autopairs.rule")
            local conds = require("nvim-autopairs.conds")

            -- Autoclosing angle brackets
            nvim_autopairs.add_rule(
                -- This rule is disabled for HTML, JSX etc. to avoid conflicts with nvim-ts-autotag
                Rule("<", ">", { "-html", "-xml", "-markdown", "-javascriptreact", "-typescriptreact" })
                    :with_pair(conds.before_regex("%a+:?:?$", 3))
                    :with_move(function(cond_opts)
                        return cond_opts.char == ">"
                    end)
            )
        end,
    },
}
