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
-- FILETYPE: C
-- ============================================================

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'c', 'cpp' },
    group   = vim.api.nvim_create_augroup('ft-c', { clear = true }),
    callback = function()
        vim.opt_local.colorcolumn = '80'    -- K&R / Linux kernel style: 80 cols
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

-- ============================================================
-- FILETYPE: MARKDOWN
-- ============================================================

local md_group = vim.api.nvim_create_augroup('ft-markdown', { clear = true })

-- Fold YAML frontmatter (--- ... ---) on open, if present
vim.api.nvim_create_autocmd('FileType', {
    pattern  = 'markdown',
    group    = md_group,
    callback = function()
        if vim.fn.getline(1) == '---' then
            vim.cmd('1,/^---$/ fold')
            vim.cmd('normal! zc')
        end
    end,
})

-- Checkbox virtual text: replace [ ] [x] [-] [>] with icons via extmarks.
-- The raw checkbox syntax is concealed; the icon is overlaid at the same position.
local checkbox_ns = vim.api.nvim_create_namespace('markdown_checkboxes')
local checkbox_icons = {
    ['[ ]'] = '◯',
    ['[x]'] = '●',
    ['[-]'] = '⊘',
    ['[>]'] = '▷',
}

vim.api.nvim_create_autocmd('FileType', {
    pattern  = 'markdown',
    group    = md_group,
    callback = function(args)
        local bufnr = args.buf

        -- Concealment: hide raw checkbox text so only the icon shows
        vim.opt_local.conceallevel  = 2
        vim.opt_local.concealcursor = 'nc'  -- conceal in normal + command mode
        vim.fn.matchadd('Conceal', '\\[ \\]')
        vim.fn.matchadd('Conceal', '\\[x\\]')
        vim.fn.matchadd('Conceal', '\\[-\\]')
        vim.fn.matchadd('Conceal', '\\[>\\]')

        -- Render icon extmarks for every checkbox in the buffer
        local function render_checkboxes()
            vim.api.nvim_buf_clear_namespace(bufnr, checkbox_ns, 0, -1)
            for row, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
                local dash_col, _, checkbox = line:find('%- (%[[ x%->]%])')
                if dash_col and checkbox and checkbox_icons[checkbox] then
                    vim.api.nvim_buf_set_extmark(bufnr, checkbox_ns, row - 1, dash_col - 1, {
                        virt_text     = { { checkbox_icons[checkbox], 'Conceal' } },
                        virt_text_pos = 'overlay',
                        hl_mode       = 'combine',
                    })
                end
            end
        end

        render_checkboxes()

        -- Re-render on every text change so icons stay in sync while editing
        vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
            buffer   = bufnr,
            callback = render_checkboxes,
        })
    end,
})
