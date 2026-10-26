---@class ne.util.lockfile
---@field path string
local Lockfile = {}
Lockfile.__index = Lockfile

---@param path string
---@return ne.util.lockfile
function Lockfile.new(path)
	return setmetatable({ path = path }, Lockfile)
end

---@return table<string, any>?
function Lockfile:all()
	local file = io.open(self.path, 'r')
	if not file then
		return {}
	end

	local ok, entries = pcall(vim.json.decode, file:read('*a'))
	file:close()

	if not ok or type(entries) ~= 'table' then
		vim.notify('Could not parse ' .. self.path .. ', leaving it unchanged', vim.log.levels.ERROR)
		return nil
	end

	return entries
end

---@param key string
---@return any?
function Lockfile:get(key)
	local entries = self:all()
	return entries and entries[key]
end

---@param entries table<string, any>
function Lockfile:replace(entries)
	local file, err = io.open(self.path, 'w')
	if not file then
		vim.notify('Could not write ' .. self.path .. ': ' .. err, vim.log.levels.WARN)
		return
	end

    local value = next(entries) == nil and vim.empty_dict() or entries
	file:write(vim.json.encode(value, { indent = '  ', sort_keys = true, }) .. '\n')
	file:close()
end

---@param name string
---@param value? any
function Lockfile:set(name, value)
	local entries = self:all()
	if not entries then
		return
	end
	entries[name] = value
	self:replace(entries)
end

return Lockfile
