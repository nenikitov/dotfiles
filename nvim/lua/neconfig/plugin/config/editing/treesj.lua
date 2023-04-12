return {
    'Wansmer/treesj',
    config = function()
        require('treesj').setup {
            use_default_keymaps = false,
        }

        require('neconfig.user.keymaps').split_join()
    end
}
