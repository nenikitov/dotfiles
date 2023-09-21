local languages = require('languages.treesitter')
local keymaps = require('user.keymaps')

return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function(_, opts)
        require('nvim-treesitter.configs').setup(opts)
        keymaps.treesitter()
    end,
    opts = function()
        return {
            ensure_installed = languages,
            sync_install = false,
        }
    end
}
