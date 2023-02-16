--#region Helpers

-- Treesitter
local treesitter_status, treesitter = pcall(require, 'nvim-treesitter.configs')
if not treesitter_status then
    vim.notify('Treesitter not available', vim.log.levels.ERROR)
    return
end

local function color_of_identifier(identifier)
    local colors = vim.api.nvim_get_hl_by_name(identifier, true)
    local foreground = colors.foreground
    if foreground ~= nil then
        return '#' .. string.format('%06x', foreground)
    else
        return nil
    end
end

--#endregion


--#region Treesitter

-- Treesitter
treesitter.setup {
    -- General
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
    -- Autotag
    autotag = {
        enable = true
    },
    -- Refactor
    refactor = {
        hightlight_definitions = {
            enable = true
        }
    },
    -- Context comment string
    context_commentstring = {
        enable = true
    },
    -- Rainbow parentheses
    rainbow = {
        enable = false,
        extended_mode = true
    },
    -- Playground
    playground = {
        enable = true
    },
    -- Navigation
    textobjects = {
        select = {
            enable = true,
            keymaps = require('neconfig.user.keymaps').treesitter_textobjects(),
        }
    }
}


-- Keymaps
require('neconfig.user.keymaps').treesitter()

--#endregion

