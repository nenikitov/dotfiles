local util = require('util')

---@class ne.defs.keys
local M = {}

M.custom = util.map:k('<LEADER>', 'Custom')
M.custom_local = util.map:k('<LOCALLEADER>', 'Custom')

M.buffer = M.custom:k('b', 'buffer/window')
M.plugin = M.custom:k('p', 'plugin')
M.code = M.custom:k('c', 'code')
M.git = M.custom:k('g', 'git')

return M
