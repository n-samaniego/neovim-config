-- ============================================================
-- GENERAL
-- ============================================================

-- Flash the yanked region briefly after any yank operation
vim.api.nvim_create_autocmd('TextYankPost', {
    desc  = 'Highlight yanked text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
})

-- Autosave on leaving insert mode (only for real, named file buffers)
vim.api.nvim_create_autocmd('InsertLeave', {
    group   = vim.api.nvim_create_augroup('autosave-on-insert-leave', { clear = true }),
    pattern = '*',
    callback = function()
        if vim.bo.buftype == '' and vim.fn.expand('%') ~= '' then
            vim.cmd('silent! write')
        end
    end,
})

-- Resume at last cursor position when reopening a file.
-- Skips git commits (rebase messages, etc.) where line 1 is always correct.
vim.api.nvim_create_autocmd('BufReadPost', {
    group = vim.api.nvim_create_augroup('resume-position', { clear = true }),
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local line_count = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= line_count and vim.bo.filetype ~= 'gitcommit' then
            vim.api.nvim_win_set_cursor(0, mark)
        end
    end,
})

-- ============================================================
-- FILETYPE: Python
-- ============================================================

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'python' },            -- PEP 8: 79
    callback = function() vim.opt_local.colorcolumn = '79' end,
})

-- ============================================================
-- FILETYPE: Rust
-- ============================================================

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'rust' },              -- rustfmt default: 100
    callback = function() vim.opt_local.colorcolumn = '100' end,
})

