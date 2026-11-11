local util = require('util')

---@class ne.shared.keys
local M = {}

M.custom = util.map:k('<LEADER>', 'Custom')
M.custom_local = util.map:k('<LOCALLEADER>', 'Custom')

M.buffer = M.custom:k('b', 'buffer/window')
M.buffer_new = M.buffer:k('n', 'Create new empty buffer')
M.buffer_quit = M.buffer:k('q', 'Quit window')

M.code = M.custom:k('c', 'code')

M.find = M.custom:k('f', 'find')
M.find_explorer = M.find:k('e', 'Explorer')
M.find_files = M.find:k('f', 'Files')
M.find_grep = M.find:k('g', 'Grep')

M.git = M.custom:k('g', 'git')

M.plugin = M.custom:k('p', 'plugin')
M.plugin_lazy = M.plugin:k('l', 'lazy.nvim')
M.plugin_mason = M.plugin:k('m', 'Mason')

return M
