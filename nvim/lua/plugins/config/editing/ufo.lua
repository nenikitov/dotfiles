local icons = require('user.icons')

return {
    'kevinhwang91/nvim-ufo',
    dependencies = {
        'kevinhwang91/promise-async',
        'nvim-treesitter/nvim-treesitter'
    },
    config = true,
    opts = function()
        local promise = require('promise')
        local ufo = require('ufo')

        local function fallback_selector(bufnr)
            local fallback_exception = 'UfoFallbackException'

            local chain = promise.reject(fallback_exception)
            for _, provider in ipairs { 'lsp', 'treesitter', 'indent' } do
                chain = chain:catch(function(err)
                    if not err:match(fallback_exception) then
                        return promise.reject(err)
                    end
                    return ufo.getFolds(bufnr, provider)
                end)
            end

            return chain
        end
        local handler = function(text_chunks, line_start, line_end, screen_width, truncate)
            local result = {}

            local indicator = (' ' .. icons.fill_chars.foldopen .. ' %d ... '):format(line_end - line_start)
            local indicator_width = vim.fn.strdisplaywidth(indicator)

            local width_left = screen_width - indicator_width
            local current_width = 0
            for _, chunk in ipairs(text_chunks) do
                local text = chunk[1]
                local hl = chunk[2]

                local width = vim.fn.strdisplaywidth(text)
                if width_left > current_width + width then
                    table.insert(result, chunk)
                else
                    text = truncate(text, width_left - current_width)
                    table.insert(result, { text, hl })
                    width = vim.fn.strdisplaywidth(text)
                    if current_width + width < width_left then
                        indicator = indicator .. (' '):rep(width_left - current_width - width)
                    end
                    break
                end
                current_width = current_width + width
            end
            table.insert(result, { indicator, 'UfoFoldedEllipsis' })
            return result
        end

        return {
            provider_selector = function() return fallback_selector end,
            fold_virt_text_handler = handler
        }
    end
}
