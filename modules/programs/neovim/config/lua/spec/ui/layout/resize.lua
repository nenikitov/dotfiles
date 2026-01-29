local fn = require("util.fn")
local lazy_keys = require("lazy.core.handler.keys")

local resize_horizontal = 2
local resize_vertical = 1

local function resize(direction)
    local is_horizontal = direction == "h" or direction == "l"
    local is_positive = direction == "l" or direction == "j"

    local curr = vim.fn.winnr()
    local next = vim.fn.winnr(is_horizontal and "l" or "j")
    local prev = vim.fn.winnr(is_horizontal and "h" or "k")

    local target = nil
    if next ~= curr then
        target = curr
    elseif prev ~= curr then
        target = prev
    else
        return
    end

    local resize_fn = is_horizontal and vim.fn.win_move_separator or vim.fn.win_move_statusline
    resize_fn(target, (is_positive and 1 or -1) * (is_horizontal and resize_horizontal or resize_vertical))
    require("bufresize").register()
end

return {
    "kwkarlwang/bufresize.nvim",
    config = function(_, opts)
        require("bufresize").setup(opts)

        -- Also add support for closing windows
        local group = vim.api.nvim_create_augroup("bufresize", {})
        vim.api.nvim_create_autocmd({ "WinClosed" }, {
            group = group,
            callback = function()
                require("bufresize").register()
                require("bufresize").block_register()
            end,
        })
        vim.api.nvim_create_autocmd({ "WinEnter" }, {
            group = group,
            callback = function()
                require("bufresize").resize_close()
            end,
        })
    end,
    opts = {
        resize = { increment = false },
    },
    keys = {
        { "<A-S-l>", fn.bind(resize, "l"), desc = "Resize right" },
        { "<A-S-h>", fn.bind(resize, "h"), desc = "Resize left" },
        { "<A-S-j>", fn.bind(resize, "j"), desc = "Resize down" },
        { "<A-S-k>", fn.bind(resize, "k"), desc = "Resize up" },
    },
    event = "VeryLazy",
}
