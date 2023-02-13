--#region Helpers

-- Noice
local noice_status, noice = pcall(require, 'noice')
if not noice_status then
    vim.notify('Noice not available', vim.log.levels.ERROR)
    return
end

--#endregion


--#region Noice

noice.setup {
    cmdline = {
        enabled = false
    },
    messages = {
        enabled = false
    },
    popupmenu = {
        enabled = false
    },
    notify = {
        enabled = false
    },
    health = {
        checker = false
    },
    smart_move = {
        checker = false
    },
    lsp = {
        override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true,
        }
    },
    presets = {
        lsp_doc_border = true,
    }
}

--#endregion

