require("pre_setup")

-- Clone
local path_lazy = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(path_lazy) then
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        path_lazy,
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
local Event = require("lazy.core.handler.event")
Event.mappings.LazyFile = { id = "LazyFile", event = { "BufReadPre", "BufNewFile", "BufWritePre", "FileType" } }

-- Setup other plugins
require("lazy").setup({
    spec = { import = "spec" },
    defaults = { lazy = true },
    install = { colorscheme = vim.g.colorschemes },
    ui = {
        border = vim.opt.winborder:get(),
        backdrop = 100,
    },
    change_detection = { notify = false },
})
