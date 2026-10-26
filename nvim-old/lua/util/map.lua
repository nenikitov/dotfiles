local opts_default = {
    noremap = true,
    silent = true,
}

local function map(modes, keys, func, desc, opts)
    opts = vim.tbl_deep_extend("force", opts_default, opts or {}, { desc = desc })
    vim.keymap.set(modes, keys, func, opts)
end

return map
