local icon = require('util.icon')

-- TODO: separate this function
local function overwrite_defaults(keys_default, keys_new)
    local d = vim.iter(pairs(keys_default))
    :map(function(k) return {k, false} end)
    :fold({}, function(acc, e)
        acc[e[1]] = e[2]
        return acc
    end)
    return vim.tbl_deep_extend('force', d, keys_new)
end

return {
    'snacks.nvim',
    opts = function(_, opts)
        local defaults = require('snacks.picker.config.sources').explorer

        return vim.tbl_deep_extend('force', opts, {
            explorer = {},
            picker = {
                sources = {
                    explorer = {
                        hidden = true,
                        ignored = true,
                        auto_close = true,
                        layout = {
                            preview = true,
                            layout = {
                                backdrop = false,
                                box = 'horizontal',
                                position = 'float',
                                width = 0.8,
                                height = 0.8,
                                {
                                    box = "vertical",
                                    width = 0.2,
                                    min_width = 40,
                                    border = vim.o.winborder or "rounded",
                                    title = "{title} {live} {flags}",
                                    { win = "input", height = 1, border = "bottom" },
                                    { win = "list", border = "none" },
                                },
                                {
                                    win = "preview",
                                    title = "{preview}",
                                    border = vim.o.winborder or "rounded",
                                },
                            }
                        },
                        win = { list = { keys = overwrite_defaults(defaults.win.list.keys, {
                            -- Navigation
                            ["]g"] = "explorer_git_next",
                            ["[g"] = "explorer_git_prev",
                            ["]d"] = "explorer_diagnostic_next",
                            ["[d"] = "explorer_diagnostic_prev",
                            ["]w"] = "explorer_warn_next",
                            ["[w"] = "explorer_warn_prev",
                            ["]e"] = "explorer_error_next",
                            ["[e"] = "explorer_error_prev",
                            -- Accept
                            ['l'] = { 'confirm' },
                            ['m'] = { 'explorer_select' },
                            -- Explorer actions
                            ['h'] = { 'explorer_close' },
                            ['a'] = { 'explorer_add' },
                            ['d'] = { 'explorer_del' },
                            ['r'] = { 'explorer_rename' },
                            ['y'] = { 'explorer_yank', mode = { 'n', 'x' } },
                            ['Y'] = { 'explorer_copy_path' },
                            ['x'] = { 'explorer_move' },
                            ['p'] = { 'explorer_paste' },
                            ['<BS>'] = { 'explorer_up' },
                            ['<RETURN>'] = { 'tcd' },
                        }) } },
                        actions = {
                            explorer_select = function(picker)
                                picker.list:select()
                            end,
                            explorer_copy_path = function(_, item)
                                local modify = vim.fn.fnamemodify
                                local path = item.file
                                local name = modify(path, ':t')

                                local results = {
                                    path,
                                    modify(path, ':.'),
                                    modify(path, ':~'),
                                    name,
                                    modify(name, ':r'),
                                    modify(name, ':e'),
                                }

                                local options = {
                                    'Path absolute: ' .. results[1],
                                    'Path relative to CWD: ' .. results[2],
                                    'Path relative to HOME: ' .. results[3],
                                    'Name: ' .. results[4],
                                }

                                if vim.fn.isdirectory(path) == 0 then
                                    vim.list_extend(options, {
                                        'Name without extension: ' .. results[5],
                                        'extension: ' .. results[6],
                                    })
                                end

                                vim.ui.select(options, { prompt = 'What to copy' }, function(choice, i)
                                    if not choice then
                                        return
                                    end
                                    if not i then
                                        return
                                    end
                                    vim.fn.setreg('+', results[i])
                                end)
                            end
                        }
                    },
                }
            }
        })
    end,
    keys = {
        -- Prefix
        { [[<LEADER>e]], [[<NOP>]], desc = 'file explorer' },
        -- Tree
        { [[<LEADER>et]], function() Snacks.explorer() end, desc = 'Tree file explorer' },
    }
}
