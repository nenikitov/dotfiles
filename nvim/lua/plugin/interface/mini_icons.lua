---@module 'lazy'

local shared = require('shared')

---@type LazySpec
return {
    shared.plugins.names.mini_icons,
	opts = {
        style = shared.settings.enable_tty_mode and 'ascii' or 'glyph',
        lsp = {
            array         = { glyph = shared.icons.token.array },
            boolean       = { glyph = shared.icons.token.boolean },
            class         = { glyph = shared.icons.token.class },
            color         = { glyph = shared.icons.token.color },
            constant      = { glyph = shared.icons.token.constant },
            constructor   = { glyph = shared.icons.token.constructor },
            enum          = { glyph = shared.icons.token.enum },
            enummember    = { glyph = shared.icons.token.enum_member },
            event         = { glyph = shared.icons.token.event },
            field         = { glyph = shared.icons.token.field },
            file          = { glyph = shared.icons.token.file },
            folder        = { glyph = shared.icons.token.folder },
            ['function']  = { glyph = shared.icons.token['function'] },
            interface     = { glyph = shared.icons.token.interface },
            key           = { glyph = shared.icons.token.key },
            keyword       = { glyph = shared.icons.token.keyword },
            misc          = { glyph = shared.icons.token.misc },
            method        = { glyph = shared.icons.token.method },
            module        = { glyph = shared.icons.token.module },
            namespace     = { glyph = shared.icons.token.namespace },
            null          = { glyph = shared.icons.token.null },
            number        = { glyph = shared.icons.token.number },
            object        = { glyph = shared.icons.token.object },
            operator      = { glyph = shared.icons.token.operator },
            package       = { glyph = shared.icons.token.package },
            property      = { glyph = shared.icons.token.property },
            reference     = { glyph = shared.icons.token.reference },
            snippet       = { glyph = shared.icons.token.snippet },
            string        = { glyph = shared.icons.token.string },
            struct        = { glyph = shared.icons.token.struct },
            text          = { glyph = shared.icons.token.text },
            typeparameter = { glyph = shared.icons.token.type_parameter },
            unit          = { glyph = shared.icons.token.unit },
            value         = { glyph = shared.icons.token.value },
            variable      = { glyph = shared.icons.token.variable },
        },
	},
	init = function()
		-- Plugins asking for nvim-web-devicons get mini.icons instead, loaded on first use
		package.preload['nvim-web-devicons'] = function()
			require('mini.icons').mock_nvim_web_devicons()
			return package.loaded['nvim-web-devicons']
		end
	end,
}
