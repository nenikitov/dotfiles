---@class ne.util
---@field collection ne.util.collection
---@field fs ne.util.fs
---@field lockfile ne.util.lockfile
---@field map ne.util.map.Node
---@field vim ne.util.vim
local M = require('util.fs').dir_module(...)
return M
