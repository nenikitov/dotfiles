---@module 'lazy'
---@module 'snacks'

local shared = require('shared')
local util = require('util')

---@param buf integer
---@return boolean
local function should_show(buf)
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local wins = vim.tbl_filter(function(win) return vim.api.nvim_win_get_config(win).relative == '' end,
        vim.api.nvim_list_wins())
    return vim.fn.argc(-1) == 0
        and vim.api.nvim_buf_get_name(buf) == ''
        and #lines == 1 and lines[1] == ''
        and #wins == 1
end

---@param win integer
---@return vim.api.keyset.win_config
local function layout(win)
    return {
        relative = 'win',
        win = win,
        row = 1,
        col = 0,
        width = vim.api.nvim_win_get_width(win),
        height = math.max(vim.api.nvim_win_get_height(win) - 1, 1),
    }
end

---@param buf integer
---@param win integer
local function show(buf, win)
    local dashboard = require('snacks.dashboard')

    local shortmess = vim.o.shortmess
    vim.opt.shortmess:append('I')
    local group = util.vim.augroup('ne.plugin.snacks_dashboard_overlay_watch')
    local dashboard_buf = vim.api.nvim_create_buf(false, true)

    local function hide()
        vim.o.shortmess = shortmess
        pcall(vim.api.nvim_del_augroup_by_id, group)
        vim.schedule(function() pcall(vim.api.nvim_buf_delete, dashboard_buf, { force = true }) end)
    end

    local dashboard_win = vim.api.nvim_open_win(
        dashboard_buf,
        false,
        vim.tbl_extend('force', layout(win), {
            focusable = false,
            style = 'minimal',
            border = 'none',
            zindex = Snacks.config.styles.dashboard.zindex,
        })
    )
    ---@diagnostic disable-next-line: missing-fields
    dashboard.open({ buf = dashboard_buf, win = dashboard_win })

    util.vim.autocmd({
        -- Typing or any other edit, including paste and ex commands like :put
        'InsertEnter',
        'TextChanged',
        'TextChangedI',
        -- Another buffer replaces it in the window
        'BufWinLeave',
        -- :enew and :edit reuse the empty startup buffer instead of leaving it
        'BufUnload',
    }, {
        group = group,
        buffer = buf,
        desc = 'Hide dashboard overlay when the text is typed',
        nested = true,
        callback = hide,
    })

    util.vim.autocmd({
        -- Splitting the window, floats like pickers, notifications, and the cmdline keep the overlay
        'WinNew',
    }, {
        group = group,
        desc = 'Hide dashboard overlay when no longer active',
        nested = true,
        callback = function()
            if vim.api.nvim_win_get_config(0).relative == '' then hide() end
        end,
    })

    util.vim.autocmd({
        -- Layout is centered for a specific size
        'VimResized',
        'WinResized',
    }, {
        group = group,
        desc = 'Resize dashboard overlay with its window',
        nested = true,
        callback = function()
            vim.api.nvim_win_set_config(dashboard_win, layout(win))
        end,
    })

    util.vim.autocmd({
        -- Plugins loaded after the first draw are missing from the startup stats
        { 'User', pattern = 'VeryLazy' },
    }, {
        group = group,
        desc = 'Redraw dashboard overlay with final startup stats',
        once = true,
        callback = vim.schedule_wrap(function()
            dashboard.lazy_stats = nil
            dashboard.update()
        end),
    })
end

---@param lhs string
---@return string
local function key_label(lhs)
    local keys = vim.fn.keytrans(vim.keycode(lhs))
    local label = keys:gsub('<(.-)>', function(name) return name:gsub('([^-]+)%-?', shared.icons.key_names) end)
    return label
end

---@param glyphs string[]
---@param colors string[]
---@param hls table<string, string[]>
---@return snacks.dashboard.Text[]
local function logo(glyphs, colors, hls)
    ---@type table<string, string?>
    local resolved_hls = vim.tbl_map(util.vim.find_hl, hls)

    ---@type snacks.dashboard.Text[]
    local result = {}

    for y, line in ipairs(glyphs) do
        if y > 1 then table.insert(result, { '\n' }) end
        for x, glyph in ipairs(vim.fn.split(line, '\\zs')) do
            table.insert(result, { glyph, hl = resolved_hls[colors[y]:sub(x, x)] })
        end
    end

    return result
end

---@type LazySpec
return {
    shared.plugins.names.snacks,
    dependencies = {
        shared.plugins.names.mini_icons,
    },
    ---@param opts snacks.Config
    ---@return snacks.Config
    opts = function(_, opts)
        return vim.tbl_deep_extend('force', opts, {
            dashboard = {
                enabled = false,
                preset = {
                    keys = vim.tbl_map(
                        function(item)
                            return { icon = item.icon, key = key_label(item[1]:lhs()), desc = item[1]:desc() }
                        end,
                        {
                            { shared.keys.buffer_new,   icon = shared.icons.dashboard.actions.new_file },
                            { shared.keys.find_files,   icon = shared.icons.dashboard.actions.find_file },
                            { shared.keys.find_grep,    icon = shared.icons.dashboard.actions.find_text },
                            { shared.keys.plugin_lazy,  icon = shared.icons.dashboard.actions.lazy },
                            { shared.keys.plugin_mason, icon = shared.icons.dashboard.actions.mason },
                            { shared.keys.buffer_quit,  icon = shared.icons.dashboard.actions.quit },
                        }
                    ),
                },
                sections = {
                    { text = logo(shared.icons.logo.glyphs, shared.icons.logo.colors, shared.icons.logo.hls), align = 'center', padding = 1 },
                    { icon = shared.icons.dashboard.sections.keymaps, title = 'Keymaps', padding = 1 },
                    { section = "keys", padding = 1 },
                    { icon = shared.icons.dashboard.sections.startup, section = 'startup', align = 'left' },
                },
            },
        })
    end,
    init = function()
        util.vim.autocmd({ 'UIEnter' }, {
            group = util.vim.augroup('ne.plugin.snacks_dashboard_overlay'),
            desc = 'Show snacks dashboard as an overlay on the startup buffer',
            once = true,
            nested = true,
            callback = function()
                local buf = vim.api.nvim_get_current_buf()
                if should_show(buf) then
                    show(buf, vim.api.nvim_get_current_win())
                end
            end,
        })
    end,
}
