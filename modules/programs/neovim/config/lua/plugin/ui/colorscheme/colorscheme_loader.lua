return {
    "nenikitov/colorscheme-loader.nvim",
    opts = {
        custom = vim.g.colorschemes,
    },
    -- HACK: set color scheme before any other plugin loads
    init = function(spec)
        require("colorscheme_loader").setup(spec.opts)
    end,
    config = function() end,
}
