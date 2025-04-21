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

vim.opt.rtp:prepend(path_lazy)

require('lazy').setup({
    spec = {
        { import = "plugin.spec" }
    },
    defaults = { lazy = true },
    install = { colorscheme = vim.g.colorschemes },
    ui = {
        border = vim.o.winborder
    },
    change_detection = { notify = false }
})
