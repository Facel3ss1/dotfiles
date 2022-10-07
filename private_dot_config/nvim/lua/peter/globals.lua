-- Shorthand for `print(vim.inspect(v))`. Returns the argument.
--- @param v any # The value to print
--- @return any
P = function(v)
    print(vim.inspect(v))
    return v
end
