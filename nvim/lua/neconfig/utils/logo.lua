--#region Helpers

--- Module return.
local M = {}

--#endregion



--#region Types

---@class LogoSpan
---@field body string
---@field highlight string

---@alias LogoLine LogoSpan[]

--#endregion



--#region Logo

--- Create a new span for the logo.
---@param body string
---@param highlight string
---@return LogoSpan
function M.new_span(body, highlight)
    return {
        body = body,
        highlight = highlight
    }
end

--- Create a new logo with colors.
---@param ... LogoLine
---@return { text: string[], highlights: table[] }
function M.new_logo(...)
    ---@type string[]
    local text = {}
    ---@type table[]
    local highlights = {}

    for _, line in ipairs({...}) do
        local t = ''
        local h = {}

        for _, span in ipairs(line) do
            table.insert(h, {
                span.highlight,
                t:len(), t:len() + span.body:len()
            })
            t = t .. span.body
        end

        table.insert(text, t)
        table.insert(highlights, h)
    end

    return {
        text = text,
        highlights = highlights
    }
end

--#endregion



--#region Exports

return M

--#endregion

