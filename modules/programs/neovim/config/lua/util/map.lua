local M = {}

local opts_default = {
    noremap = true,
    silent = true,
}

function M.map(modes, keys, func, desc, opts)
    opts = vim.tbl_deep_extend("force", opts_default, opts or {}, { desc = desc })
    vim.keymap.set(modes, keys, func, opts)
end

function M.bind(fn, ...)
    local args = { ... }
    return function()
        return fn(unpack(args))
    end
end

return M
