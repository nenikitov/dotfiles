--#region Helpers

-- Treesitter
local treesitter_status, treesitter = pcall(require, "nvim-treesitter.configs")
if not treesitter_status then
    vim.notify('Treesitter not available', vim.log.levels.ERROR)
    return
end

--#endregion

treesitter.setup {
    ensure_installed = 'all',
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
    },
    indent = {
        enable = true
    }
}

