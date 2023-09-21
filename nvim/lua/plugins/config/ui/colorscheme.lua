local function colorscheme(args)
    args.priority = 1000
    return args
end

local function colorscheme_loader()
    return {
        dir = '',
        name = 'autoload-colorscheme',
        priority = 999,
        config = function()
            require('user.colorscheme').apply()
        end,
    }
end

return {
    colorscheme_loader(),
    colorscheme {
        'akinsho/horizon.nvim'
    }
}
