---@class ne.util.fs
local M = {}

--#region General

---@param path string
---@return string[]
function M.split(path)
	return vim.split(vim.fs.normalize(path), '/', { plain = true })
end

--#endregion

--#region Path shortening and unique

---@param path string
---@return string prefix, string rest
local function split_prefix(path)
    local scheme = path:match('^[^:/\\?#]+://')
    if scheme then
        return scheme, path:sub(#scheme + 1)
    end
    for _, prefix in ipairs({ '//', '/', '~' }) do
        if vim.startswith(path, prefix) then
            return prefix, path:sub(#prefix + 1)
        end
    end
    return '', path
end

---@param parts string[]
---@param section string[]
---@return boolean
local function contains_section(parts, section)
	for i = 1, #parts - #section + 1 do
		if vim.deep_equal(vim.list_slice(parts, i, i + #section - 1), section) then
			return true
		end
	end
	return false
end

---@param parts string[]
---@param section string[]
---@return boolean
local function ends_with_section(parts, section)
	return #parts >= #section and vim.deep_equal(vim.list_slice(parts, #parts - #section + 1), section)
end

---@param parts string[]
---@param prefix string
---@param start integer
---@param stop integer
---@param ellipsis string
---@return string
local function format_label(parts, prefix, start, stop, ellipsis)
	local section = table.concat(parts, '/', start, stop)
	local result = ''

	-- Preserve a Windows drive or root prefix
	if parts[1]:match(':$') or prefix ~= '' then
		if start == 2 then
			-- Extend the section to include the drive or first directory
			start = 1
			section = parts[1] .. '/' .. section
		end
		if start > 1 then
			result = parts[1] .. '/'
		end
		result = prefix .. result
	end

	if start > 1 then
		result = result .. ellipsis .. '/'
	end

	result = result .. section

	if stop < #parts then
		-- Keep a trailing slash if the path had one
		if stop == #parts - 1 and parts[#parts] == '' then
			result = result .. '/'
		else
			result = result .. '/' .. ellipsis
		end
	end

	return result
end

---@param paths string[]
---@param ellipsis? string
---@return string[] shortened same order as `paths`
function M.shorten(paths, ellipsis)
	ellipsis = ellipsis or '…'

	local all_parts = vim.tbl_map(function(path)
		return vim.split(path, '/', { plain = true })
	end, paths)

	local shortened = {}
	for i, path in ipairs(paths) do
		shortened[i] = path

        if path == '' then
            goto continue
        end

        local prefix, trimmed = split_prefix(path)
        local segments = vim.split(trimmed, '/', { plain = true })

        ---@param start integer
        ---@param stop integer
        local function clashes(start, stop)
            local section = vim.list_slice(segments, start, stop)
            local ending = stop == #segments

            for other_index, other in ipairs(all_parts) do
                if other_index ~= i and paths[other_index] ~= ''
                    and contains_section(other, section)
                    and (not ending or ends_with_section(other, section))
                then
                    return true
                end
            end
            return false
        end

        local found = false
        for length = 1, #segments do
            for start = #segments - length + 1, 1, -1 do
                local stop = start + length - 1
                if not clashes(start, stop) then
                    shortened[i] = format_label(segments, prefix, start, stop, ellipsis)
                    found = true
                    break
                end
            end
            if found then
                break
            end
        end

        ::continue::
	end

	return shortened
end

---@param path string
---@param max integer
---@param ellipsis? string
---@return string
function M.truncate(path, max, ellipsis)
	local width = vim.api.nvim_strwidth
	ellipsis = ellipsis or '…'

    -- As is
	if width(path) <= max then
		return path
	end

    -- Shortened by vim
	local shortened = vim.fn.pathshorten(path)
	if width(shortened) <= max then
		return shortened
	end

    -- Drop leading directories
	local parts = M.split(shortened)
	while #parts > 1 and width(ellipsis .. '/' .. table.concat(parts, '/')) > max do
		table.remove(parts, 1)
	end

	local result = ellipsis .. '/' .. table.concat(parts, '/')
	if width(result) <= max then
		return result
	end

    -- Cut characters from the beginning
	local last = parts[#parts]
	local keep = math.max(max - width(ellipsis), 0)
	return ellipsis .. vim.fn.strcharpart(last, vim.fn.strcharlen(last) - keep)
end

--#endregion

--#region Modules

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

    path, _ = path:gsub('/init%.lua$', ''):gsub('%.lua$', '')
    return table.concat(M.split(path), '.')
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

--#endregion

return M
