local map = require("util.map")

local function augroup(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end

-- Highlight text for some time after yanking
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup("yank highlight"),
    callback = function()
        vim.hl.on_yank({
            higroup = "Visual",
            on_visual = true,
        })
    end,
    desc = "Highlight text for some time after yanking",
})

-- Check if a buffer was updated outside neovim and needs to be reloaded
vim.api.nvim_create_autocmd({ "FocusGained", "BufWinEnter", "TermClose", "TermLeave" }, {
    group = augroup("file update"),
    callback = function()
        if vim.opt.buftype:get() ~= "nofile" then
            vim.cmd("checktime")
        end
    end,
    desc = "Check if a buffer was updated outside neovim and needs to be reloaded",
})

-- Return cursor to the last position when file was opened
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWinEnter" }, {
    group = augroup("return last position"),
    callback = function()
        local ignore_buftype = { "quickfix", "nofile", "help", "terminal", "prompt" }
        local ignore_filetype = { "gitcommit", "gitrebase" }

        if vim.tbl_contains(ignore_buftype, vim.bo.buftype) then
            return
        end
        if vim.tbl_contains(ignore_filetype, vim.bo.filetype) then
            return
        end

        local row, col = unpack(vim.api.nvim_buf_get_mark(0, '"'))

        -- We never opened this file
        if row == 0 and col == 0 then
            return
        end

        local rows = vim.api.nvim_buf_line_count(0)
        if row > rows then
            row = rows
        end

        local cols = #vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
        if col > cols then
            col = cols
        end

        vim.api.nvim_win_set_cursor(0, { row, col })
    end,
    desc = "Return cursor to the last position when file was opened",
})

-- Delete trailing whitespaces and newlines on save
vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup("auto format"),
    callback = function()
        -- Substitution moves the cursor, we need to restore it
        local view = vim.fn.winsaveview()

        -- Remove trailing whitespaces
        vim.api.nvim_command([[%s/\s\+$//e]])
        -- Remove trailing newlines
        local last_line = vim.api.nvim_buf_line_count(0)
        local last_non_blank_line = vim.fn.prevnonblank(last_line)
        if last_non_blank_line < last_line then
            vim.api.nvim_buf_set_lines(0, last_non_blank_line, last_line, true, {})
        end

        vim.fn.winrestview(view)
    end,
    desc = "Delete trailing white spaces and newlines on save",
})

-- Close some windows with `q` or `ESC`
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("fast close"),
    pattern = {
        "checkhealth",
        "help",
        "lspinfo",
        "man",
        "lazy",
        "notify",
        "query",
    },
    callback = function(event)
        local function close()
            vim.cmd("close")
            pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
        end
        local args = { buffer = event.buf }
        map.map("n", "q", close, "Quit", args)
        map.map("n", "<ESC>", close, "Quit", args)
    end,
    desc = "Close some windows with `q` or `ESC`",
})

-- Create directory structure for a new file if doesn't exist
vim.api.nvim_create_autocmd({ "BufWritePre", "FileWritePre" }, {
    group = augroup("create dirs"),
    callback = function()
        local dir = vim.fn.expand("<afile>:p:h")

        -- Can't write to remote files (they have a prefix like ftp://)
        if dir:find([[^%l+://]]) then
            return
        end

        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, "p")
        end
    end,
    desc = "Create directory structure for a new file if doesn't exist",
})
