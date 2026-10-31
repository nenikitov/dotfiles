---@module 'heirline'

local basic = require('plugin.ui.heirline.modules.basic')
local input = require('plugin.ui.heirline.modules.input')
local layout = require('plugin.ui.heirline.layouts.basic')
local util = require('util')

local M = {}

--#region Types

-- ┌─────┬───┬───┬───────────────────────────┬───┬───┬─────┐
-- │-... │-2 │-1 │ 0 ///////////////////// 0 │ 1 │ 2 │ ... │
-- └─────┴───┴───┴───────────────────────────┴───┴───┴─────┘

---@alias ne.plugin.heirline.layout.statusline.Section ne.plugin.heirline.modules.basic.Component[]

---@alias ne.plugin.heirline.layout.statusline.Sections table<integer, ne.plugin.heirline.layout.statusline.Section>

---@class ne.plugin.heirline.layout.statusline.Spec
---@field highlight fun(active: boolean, section: integer, mode: string): (string | table)
---@field section_separator? fun(section: integer): string on the side facing the center
---@field component_separator? fun(section: integer): string separator between items of a section
---@field active ne.plugin.heirline.layout.statusline.Sections
---@field inactive? ne.plugin.heirline.layout.statusline.Sections

---@class ne.plugin.heirline.layout.statusline.Built
---@field component ne.plugin.heirline.modules.basic.Component
---@field visible fun(self: StatusLine): boolean

--#endregion

--#region Building

---@param spec ne.plugin.heirline.layout.statusline.Spec
---@param active boolean
---@param index integer
---@param section ne.plugin.heirline.layout.statusline.Section
---@return ne.plugin.heirline.layout.statusline.Built
local function build_section(spec, active, index, section)
    local sep = spec.component_separator and spec.component_separator(index) or ' '

    ---@type (fun(self: StatusLine): boolean)[]
    local shown = {}

    ---@type ne.plugin.heirline.modules.basic.Component
    local component = {
        ---@param self ne.plugin.heirline.modules.input.Context
        hl = function(self)
            return spec.highlight(active, index, self.mode)
        end,
        { provider = ' ' },
    }

    for i, item in ipairs(section) do
        shown[i] = basic.visibility(item)

        local entry = { item }
        if i > 1 and sep ~= '' then
            table.insert(entry, 1, {
                condition = util.collection.all_pass({
                    shown[i],
                    util.collection.any_pass(vim.list_slice(shown, 1, i - 1)),
                }),
                provider = sep,
            })
        end

        table.insert(component, entry)
    end

    table.insert(component, { provider = ' ' })

    local visible = util.collection.any_pass(shown)
    component.condition = visible

    return { component = component, visible = visible }
end

---@param spec ne.plugin.heirline.layout.statusline.Spec
---@param active boolean
---@param index integer
---@param visible fun(self: StatusLine): boolean
---@param neighbours { index: integer, visible: fun(self: StatusLine): boolean }[] sections toward the center, nearest first
---@return ne.plugin.heirline.modules.basic.Component?
local function build_section_separator(spec, active, index, visible, neighbours)
    local separator = spec.section_separator and spec.section_separator(index) or ''
    if separator == '' then
        return nil
    end

    return {
        condition = visible,
        provider = separator,
        ---@param self ne.plugin.heirline.modules.input.Context
        hl = function(self)
            local other = 0
            for _, neighbour in ipairs(neighbours) do
                if neighbour.visible(self) then
                    other = neighbour.index
                    break
                end
            end
            return layout.blend(
                spec.highlight(active, index, self.mode),
                spec.highlight(active, other, self.mode)
            )
        end,
    }
end

---@param spec ne.plugin.heirline.layout.statusline.Spec
---@param active boolean
---@param sections ne.plugin.heirline.layout.statusline.Sections
---@return ne.plugin.heirline.modules.basic.Component
local function build_bar(spec, active, sections)
    local indices = vim.tbl_keys(sections)
    table.sort(indices)

    ---@type table<integer, ne.plugin.heirline.layout.statusline.Built>
    local built = {}
    for _, index in ipairs(indices) do
        built[index] = build_section(spec, active, index, sections[index])
    end

    --- Sections between `index` and the center, nearest first
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
    ---@return ne.plugin.heirline.modules.basic.Component
    local function section_and_separator(index)
        local section = built[index]
        local separator = index ~= 0
            and build_section_separator(spec, active, index, section.visible, neighbours(index))
            or nil

        local parts = { section.component }
        if separator then
            table.insert(parts, index < 0 and #parts + 1 or 1, separator)
        end
        return parts
    end

    ---@type ne.plugin.heirline.modules.basic.Component
    local bar = {
        ---@param self ne.plugin.heirline.modules.input.Context
        hl = function(self)
            return spec.highlight(active, 0, self.mode)
        end,
    }

    for _, index in ipairs(indices) do
        if index < 0 then
            table.insert(bar, section_and_separator(index))
        end
    end
    table.insert(bar, { provider = '%=' })
    if built[0] then
        table.insert(bar, section_and_separator(0))
    end
    table.insert(bar, { provider = '%=' })
    for _, index in ipairs(indices) do
        if index > 0 then
            table.insert(bar, section_and_separator(index))
        end
    end

    return bar
end

--#endregion

---@param spec ne.plugin.heirline.layout.statusline.Spec
---@return ne.plugin.heirline.modules.basic.Component
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
