--#region Helpers

-- Treesitter
local treesitter_status, treesitter = pcall(require, "nvim-treesitter.configs")
if not treesitter_status then
    vim.notify('Treesitter not available', vim.log.levels.ERROR)
    return
end

local function color_of_identifier(identifier)
    local colors = vim.api.nvim_get_hl_by_name(identifier, true)
    local foreground = colors.foreground
    return '#' .. string.format('%06x', foreground)
end

--#endregion

treesitter.setup {
    -- Treesitter
    ensure_installed = 'all',
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
    },
    indent = {
        enable = true
    },
    -- Rainbow parenthesis
    rainbow = {
        enable = true,
        extended_mode = true,
         colors = {
            color_of_identifier('Special'),
            color_of_identifier('Statement'),
            color_of_identifier('Type'),
        },
        termcolors = {
            "Yellow",
            "Magenta",
            "Blue",
        }
    },
    -- Playground
    playground = {
        enable = true
    },
    -- Autotag
    autotag = {
        enable = true
    }
}
