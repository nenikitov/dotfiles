return {
    'andymass/vim-matchup',
    enabled = false,
    config = function()
        require('nvim-treesitter.configs').setup {
            matchup = {
                enable = true,
                disable_virtual_text = true
            }
        }
    end
}
