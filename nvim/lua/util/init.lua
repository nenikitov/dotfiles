---@class ne.util
---@field async ne.util.async
---@field collection ne.util.collection
---@field fs ne.util.fs
---@field lazy ne.util.lazy
---@field lockfile ne.util.lockfile
---@field map ne.util.map
---@field vim ne.util.vim
local M = require('util.fs').dir_module(...)
return M
