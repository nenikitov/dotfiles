---@class ne.util.fs
local M = {}

---@param name string
---@return string path
function M.module_to_path(name)
	return vim.fs.joinpath(
        vim.fn.stdpath('config'),
        'lua',
        unpack(vim.split(name, '.', { plain = true }))
    )
end

---@param module string
---@param opts? { recursive?: boolean }
---@return { files: string[], dirs: string[] }
function M.discover_dir(module, opts)
	---@type { recursive: boolean }
	local opts = vim.tbl_extend('force', { recursive = false }, opts or {})

	local files, dirs, seen = {}, {}, {}
	for name, kind in vim.fs.dir(M.module_to_path(module), { depth = opts.recursive and math.huge or 1 }) do
		if kind ~= 'file' or not name:match('%.lua$') or vim.fs.basename(name) == 'init.lua' then
			goto continue
		end

		local dir = vim.fs.dirname(name)
		dir = dir == '.' and module or module .. '.' .. (dir:gsub('[/\\]', '.'))

		if not seen[dir] then
			seen[dir] = true
			table.insert(dirs, dir)
		end

		table.insert(files, module .. '.' .. (name:sub(1, -5):gsub('[/\\]', '.')))

		::continue::
	end

	table.sort(files)
	table.sort(dirs)

	return { files = files, dirs = dirs }
end

---@param prefix string
---@return table module
function M.dir_module(prefix)
	return setmetatable({}, {
		__index = function(t, key)
			local name = prefix .. '.' .. key
            local path = M.module_to_path(name)

			local module
			if vim.uv.fs_stat(path .. '.lua') then
				module = require(name)
			elseif vim.fn.isdirectory(path) == 1 then
				module = M.dir_module(name)
			else
				return nil
			end

			rawset(t, key, module)

			return module
		end,
	})
end

return M
