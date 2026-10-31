---@module 'heirline'
---@module 'plugin.ui.heirline.basic'

local input = require('plugin.ui.heirline.input')
local basic = require('plugin.ui.heirline.basic')
local util = require('util')

local M = {}

--#region Types

---@class ne.plugin.heirline.layout.Flexible
---@field package _flexible true
---@field shorten? integer priority of switching to shorter variants
---@field hide? integer priority of hiding the item completely
---@field variants ne.plugin.heirline.basic.Component[] longest first

---@alias ne.plugin.heirline.layout.Item
---| ne.plugin.heirline.basic.Component
---| ne.plugin.heirline.layout.Flexible

---@class ne.plugin.heirline.layout.Section
---@field hide? integer priority of hiding the whole section and its separator
---@field [integer] ne.plugin.heirline.layout.Item

---@alias ne.plugin.heirline.layout.Sections table<integer, ne.plugin.heirline.layout.Section>

---@class ne.plugin.heirline.layout.Spec
---@field highlight fun(active: boolean, section: integer, mode: string): (string | table)
---@field section_separator? fun(section: integer): string separator on the side of a section facing the center
---@field component_separator? fun(section: integer): string separator between items of a section
---@field active ne.plugin.heirline.layout.Sections
---@field inactive? ne.plugin.heirline.layout.Sections

--#endregion

---@param opts { shorten?: integer, hide?: integer }
---@param ... ne.plugin.heirline.basic.Component
---@return ne.plugin.heirline.layout.Flexible
function M.flexible(opts, ...)
    return {
        _flexible = true,
        shorten = opts.shorten,
        hide = opts.hide,
        variants = { ... },
    }
end


---@param steps { min: integer, [1]: ne.plugin.heirline.basic.Component }[]
---@return ne.plugin.heirline.basic.Component
function M.by_width(steps)
    ---@return integer
    local function statusline_width()
        if vim.o.laststatus == 3 then
            return vim.o.columns
        end
        return vim.api.nvim_win_get_width(0)
    end

    ---@param step { min: integer, [1]: ne.plugin.heirline.basic.Component }
    local function fits(step)
        return statusline_width() >= step.min
    end

    ---@type ne.plugin.heirline.basic.Component
    local component = {
        fallthrough = false,
        condition = function(self)
            for _, step in ipairs(steps) do
                if fits(step) then
                    return basic.visibility(step[1])(self)
                end
            end
            return false
        end,
    }

    for _, step in ipairs(steps) do
        table.insert(component, {
            condition = function()
                return fits(step)
            end,
            step[1],
        })
    end

    return component
end

--#region Building

---@param hl string | table
---@return { gui?: string, cterm?: integer }
local function background(hl)
    if type(hl) == 'string' then
        local group = vim.api.nvim_get_hl(0, { name = hl, link = false })
        return { gui = group.bg and ('#%06x'):format(group.bg), cterm = group.ctermbg }
    end
    return { gui = hl.bg, cterm = hl.ctermbg }
end

---@class ne.plugin.heirline.layout.Built
---@field component ne.plugin.heirline.basic.Component
---@field visible fun(self: StatusLine): boolean

---@param spec ne.plugin.heirline.layout.Spec
---@param active boolean
---@param index integer
---@param section ne.plugin.heirline.layout.Section
---@return ne.plugin.heirline.layout.Built
local function build_section(spec, active, index, section)
    local sep = spec.component_separator and spec.component_separator(index) or ' '

    ---@type (fun(self: StatusLine): boolean)[]
    local shown = {}

    ---@type ne.plugin.heirline.basic.Component
    local component = {
        ---@param self ne.plugin.heirline.input.Context
        hl = function(self)
            return spec.highlight(active, index, self.mode)
        end,
        { provider = ' ' },
    }

    for i, item in ipairs(section) do
        local body, hide
        if item._flexible then
            ---@cast item ne.plugin.heirline.layout.Flexible
            local variants = item.variants
            if #variants > 1 and item.shorten then
                body = vim.list_extend({ flexible = item.shorten }, variants)
            else
                body = variants[1]
            end
            hide = item.hide
            shown[i] = basic.visibility(variants[1])
        else
            ---@cast item ne.plugin.heirline.basic.Component
            body = item
            shown[i] = basic.visibility(item)
        end

        local entry = { body }
        if i > 1 and sep ~= '' then
            table.insert(entry, 1, {
                condition = util.collection.all_pass({
                    shown[i],
                    util.collection.any_pass(vim.list_slice(shown, 1, i -1))
                }),
                provider = sep,
            })
        end

        if hide then
            entry = { flexible = hide, entry, {} }
        end
        table.insert(component, entry)
    end

    table.insert(component, { provider = ' ' })

    local visible = util.collection.any_pass(shown)
    component.condition = visible

    return { component = component, visible = visible }
end

---@param spec ne.plugin.heirline.layout.Spec
---@param active boolean
---@param index integer
---@param visible fun(self: StatusLine): boolean
---@param neighbours { index: integer, visible: fun(self: StatusLine): boolean }[]
---@return ne.plugin.heirline.basic.Component?
local function build_section_separator(spec, active, index, visible, neighbours)
    local section_separator = spec.section_separator and spec.section_separator(index) or ''
    if section_separator == '' then
        return nil
    end

    return {
        condition = visible,
        provider = section_separator,
        hl = function(self)
            local own = background(spec.highlight(active, index, self.mode))
            local other = background(spec.highlight(active, 0, self.mode))
            for _, neighbour in ipairs(neighbours) do
                if neighbour.visible(self) then
                    other = background(spec.highlight(active, neighbour.index, self.mode))
                    break
                end
            end
            return { fg = own.gui, ctermfg = own.cterm, bg = other.gui, ctermbg = other.cterm }
        end,
    }
end

---@param spec ne.plugin.heirline.layout.Spec
---@param active boolean
---@param sections ne.plugin.heirline.layout.Sections
---@return ne.plugin.heirline.basic.Component
local function build_bar(spec, active, sections)
    local indices = vim.tbl_keys(sections)
    table.sort(indices)

    ---@type table<integer, ne.plugin.heirline.layout.Built>
    local built = {}
    for _, index in ipairs(indices) do
        built[index] = build_section(spec, active, index, sections[index])
    end

    ---@param index integer
    local function neighbours(index)
        local list = {}
        local step = index < 0 and 1 or -1
        for i = index + step, 0, step do
            if built[i] then
                table.insert(list, { index = i, visible = built[i].visible })
            end
        end
        return list
    end

    ---@param index integer
    local function entry(index)
        local section = built[index]
        local separator = index ~= 0
            and build_section_separator(spec, active, index, section.visible, neighbours(index))
            or nil

        local parts = { section.component }
        if separator then
            table.insert(parts, index < 0 and #parts + 1 or 1, separator)
        end

        local hide = sections[index].hide
        if hide then
            return { flexible = hide, parts, {} }
        end
        return parts
    end

    ---@type ne.plugin.heirline.basic.Component
    local bar = {
        ---@param self ne.plugin.heirline.input.Context
        hl = function(self)
            return spec.highlight(active, 0, self.mode)
        end,
    }

    for _, index in ipairs(indices) do
        if index < 0 then
            table.insert(bar, entry(index))
        end
    end
    table.insert(bar, { provider = '%=' })
    if built[0] then
        table.insert(bar, entry(0))
    end
    table.insert(bar, { provider = '%=' })
    for _, index in ipairs(indices) do
        if index > 0 then
            table.insert(bar, entry(index))
        end
    end

    return bar
end

--#endregion

---@param spec ne.plugin.heirline.layout.Spec
---@return ne.plugin.heirline.basic.Component
function M.statusline(spec)
    local conditions = require('heirline.conditions')

    return input.context({
        fallthrough = false,
        {
            condition = conditions.is_active,
            build_bar(spec, true, spec.active),
        },
        build_bar(spec, false, spec.inactive or spec.active),
    })
end

return M
