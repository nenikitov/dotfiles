local path_lazy = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(path_lazy) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        path_lazy,
    })
end

vim.opt.rtp:prepend(path_lazy)

require('lazy').setup(
    'plugins.config',
    {
        ui = { border = { "/", "-", "\\", "|" } }
    }
)
