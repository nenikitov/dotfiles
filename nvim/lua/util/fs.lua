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

---@param path string
---@return string name
function M.path_to_module(path)
    path = vim.fs.normalize(path)

	if vim.fn.isabsolutepath(path) == 1 then
		local lua_root = vim.fs.joinpath(vim.fn.stdpath('config'), 'lua')
		local rel = vim.fs.relpath(lua_root, path)
		if not rel then
			error(('%s is not inside %s'):format(path, lua_root))
		end
		path = rel
	end

    path = path:gsub('[/\\]init%.lua$', ''):gsub('%.lua$', '')
	return (path:gsub('[/\\]', '.'))
end

---@param module string
---@param opts? { ignore_init?: boolean }
---@return { files: string[], dirs: string[] }
function M.discover_dir(module, opts)
	---@type { ignore_init: boolean }
	opts = vim.tbl_extend('force', { ignore_init = false }, opts or {})

    local root = M.module_to_path(module)

    ---@param dir string
    ---@return boolean
    local function has_init(dir)
        return vim.uv.fs_stat(vim.fs.joinpath(dir, 'init.lua')) ~= nil
    end

    if not opts.ignore_init and has_init(root) then
        return { files = { module }, dirs = { } }
    end

    local files, dirs = {}, {}

    ---@param dir string
	local function walk(dir)
        local importable = false

		for name, kind in vim.fs.dir(dir) do
			local path = vim.fs.joinpath(dir, name)

			if kind == 'file' and name:match('%.lua$') and name ~= 'init.lua' then
				table.insert(files, M.path_to_module(path))
                importable = true
			elseif kind == 'directory' then
				if has_init(path) then
					table.insert(files, M.path_to_module(path))
                    importable = true
				else
					walk(path)
				end
			end
		end

		if importable then
			if dir == root and has_init(root) then
				error(('%s has an init.lua, so its other files cannot be imported as a directory'):format(module))
			end
			table.insert(dirs, M.path_to_module(dir))
		end
	end

	walk(root)

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
