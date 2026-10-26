---@module 'lazy'

local defs = require('defs')

---@type LazySpec
return {
	'nvim-mini/mini.icons',
	opts = {
        style = defs.settings.enable_tty_mode and 'ascii' or 'glyph',
        lsp = {
            array         = { glyph = defs.icons.token.array },
            boolean       = { glyph = defs.icons.token.boolean },
            class         = { glyph = defs.icons.token.class },
            color         = { glyph = defs.icons.token.color },
            constant      = { glyph = defs.icons.token.constant },
            constructor   = { glyph = defs.icons.token.constructor },
            enum          = { glyph = defs.icons.token.enum },
            enummember    = { glyph = defs.icons.token.enum_member },
            event         = { glyph = defs.icons.token.event },
            field         = { glyph = defs.icons.token.field },
            file          = { glyph = defs.icons.token.file },
            folder        = { glyph = defs.icons.token.folder },
            ['function']  = { glyph = defs.icons.token['function'] },
            interface     = { glyph = defs.icons.token.interface },
            key           = { glyph = defs.icons.token.key },
            keyword       = { glyph = defs.icons.token.keyword },
            misc          = { glyph = defs.icons.token.misc },
            method        = { glyph = defs.icons.token.method },
            module        = { glyph = defs.icons.token.module },
            namespace     = { glyph = defs.icons.token.namespace },
            null          = { glyph = defs.icons.token.null },
            number        = { glyph = defs.icons.token.number },
            object        = { glyph = defs.icons.token.object },
            operator      = { glyph = defs.icons.token.operator },
            package       = { glyph = defs.icons.token.package },
            property      = { glyph = defs.icons.token.property },
            reference     = { glyph = defs.icons.token.reference },
            snippet       = { glyph = defs.icons.token.snippet },
            string        = { glyph = defs.icons.token.string },
            struct        = { glyph = defs.icons.token.struct },
            text          = { glyph = defs.icons.token.text },
            typeparameter = { glyph = defs.icons.token.type_parameter },
            unit          = { glyph = defs.icons.token.unit },
            value         = { glyph = defs.icons.token.value },
            variable      = { glyph = defs.icons.token.variable },
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
