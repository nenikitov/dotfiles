local map = require('util.map')

-- Clone
local path_lazy = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(path_lazy) then
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        path_lazy
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out .. "\n", "WarningMsg" },
            { "Press any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end

-- Initialise
vim.opt.rtp:prepend(path_lazy)

-- Event to signal that a file on disk was loaded
local Event = require('lazy.core.handler.event')
Event.mappings.LazyFile = { id = 'LazyFile', event = { 'BufReadPre', 'BufNewFile', 'BufWritePre', 'FileType' } }

-- Setup
require('lazy').setup({
    spec = {
        { import = "plugin.core" },
        { import = "plugin.language" },
        --{ import = "plugin.editor" },
        --{ import = "plugin.language" },
        --{ import = "plugin.misc" },
        --{ import = "plugin.ui" },
    },
    defaults = { lazy = true },
    install = { colorscheme = vim.g.colorschemes },
    ui = {
        border = vim.opt.winborder:get(),
        backdrop = 100,
        --title = 'lazy.nvim ' .. icon.plugin_state.lazy,
        --icons = vim.tbl_extend('force', icon.plugin_state, { list = { '-' } })
    },
    change_detection = { notify = false }
})

-- Prefix
map('n', '<LEADER>p', '<NOP>', 'plugin')
-- Maps
map('n', '<LEADER>pp', '<CMD>Lazy<CR>', 'Plugin manager')
map('n', '<LEADER>pP', function() Snacks.picker.lazy() end, 'Plugins')
