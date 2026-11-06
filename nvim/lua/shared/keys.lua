local util = require('util')

---@class ne.shared.keys
local M = {}

M.custom = util.map:k('<LEADER>', 'Custom')
M.custom_local = util.map:k('<LOCALLEADER>', 'Custom')

M.buffer = M.custom:k('b', 'buffer/window')
M.code = M.custom:k('c', 'code')
M.find = M.custom:k('f', 'find')
M.git = M.custom:k('g', 'git')
M.plugin = M.custom:k('p', 'plugin')

return M
