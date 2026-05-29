-- ============================================================
-- DIAGNOSTICS
-- ============================================================
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist,  { desc = 'Diagnostics: open quickfix list' })
vim.keymap.set('n', 'gl',        vim.diagnostic.open_float,  { desc = 'Diagnostics: open float' })

-- ============================================================
-- EDITING
-- ============================================================
-- jk to exit insert mode (home-row alternative to <Esc>)
vim.keymap.set('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })

-- H/L as more intuitive line start/end (soft-wrap aware)
-- NOTE: these shadow the built-in H/L (top/bottom of screen) — intentional
vim.keymap.set({'n', 'v', 'x'}, 'H', 'g0', { desc = 'Jump to beginning of visual line' })
vim.keymap.set({'n', 'v', 'x'}, 'L', 'g$', { desc = 'Jump to end of visual line' })

-- Move by visual lines in soft-wrap (don't skip wrapped segments)
vim.keymap.set({'n', 'x'}, 'j', 'gj', { desc = 'Down (visual line)' })
vim.keymap.set({'n', 'x'}, 'k', 'gk', { desc = 'Up (visual line)' })

-- Arrow-key movement in insert mode via Alt + hjkl
vim.keymap.set('i', '<A-h>', '<Left>',  { noremap = true, desc = 'Move left' })
vim.keymap.set('i', '<A-j>', '<Down>',  { noremap = true, desc = 'Move down' })
vim.keymap.set('i', '<A-k>', '<Up>',    { noremap = true, desc = 'Move up' })
vim.keymap.set('i', '<A-l>', '<Right>', { noremap = true, desc = 'Move right' })

-- Select whole file
vim.keymap.set('n', '<C-a>', 'ggVG', { desc = 'Select whole file' })

-- Clear search highlight
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Stay at yank position instead of jumping to end of selection
vim.keymap.set('x', 'y', 'ygv<Esc>', { desc = 'Yank without moving cursor' })

-- ============================================================
-- SURROUND (wrap visual selection)
-- ============================================================
vim.keymap.set('v', '<leader>*',  'c**<Esc>P',   { desc = 'Wrap in *...*' })
vim.keymap.set('v', '<leader>**', 'c****<Esc>hP', { desc = 'Wrap in **...**' })
vim.keymap.set('v', "<leader>'",  "c''<Esc>P",   { desc = "Wrap in '...'" })
vim.keymap.set('v', '<leader>`',  'c``<Esc>P',   { desc = 'Wrap in `...`' })
vim.keymap.set('v', '<leader>"',  'c""<Esc>P',   { desc = 'Wrap in "..."' })
vim.keymap.set('v', '<leader>(',  'c()<Esc>P',   { desc = 'Wrap in (...)' })
vim.keymap.set('v', '<leader>)',  'c()<Esc>P',   { desc = 'Wrap in (...)' })
vim.keymap.set('v', '<leader>[',  'c[]<Esc>P',   { desc = 'Wrap in [...]' })
vim.keymap.set('v', '<leader>]',  'c[]<Esc>P',   { desc = 'Wrap in [...]' })
vim.keymap.set('v', '<leader>{',  'c{}<Esc>P',   { desc = 'Wrap in {...}' })
vim.keymap.set('v', '<leader>}',  'c{}<Esc>P',   { desc = 'Wrap in {...}' })

-- ============================================================
-- TAB / COMPLETION NAVIGATION
-- ============================================================
-- Jump out of closing character (Helix-style) — shadowed if pumvisible wins
local closing_chars = {
    ["'"] = true, ['"'] = true, ['`'] = true,
    [')'] = true, [']'] = true, ['}'] = true, ['>'] = true,
}
-- Tab: jump out of closing char OR cycle completion forward
vim.keymap.set('i', '<Tab>', function()
    if vim.fn.pumvisible() ~= 0 then return '<C-n>' end
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local next_char = vim.api.nvim_get_current_line():sub(col + 1, col + 1)
    if closing_chars[next_char] then return '<Right>' end
    return '<Tab>'
end, { expr = true, noremap = true, desc = 'Tab: complete / jump-out / indent' })

vim.keymap.set('i', '<S-Tab>', function()
    if vim.fn.pumvisible() ~= 0 then return '<C-p>' end
    return '<S-Tab>'
end, { expr = true, desc = 'S-Tab: complete prev' })

-- Accept selected completion item with Enter
vim.keymap.set('i', '<CR>', function()
    if vim.fn.complete_info()['selected'] ~= -1 then return '<C-y>' end
    if vim.fn.pumvisible() ~= 0 then return '<C-e><CR>' end
    return '<CR>'
end, { expr = true, desc = 'CR: confirm completion or newline' })

-- ============================================================
-- SPLITS
-- ============================================================
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Focus left split' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Focus right split' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Focus lower split' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Focus upper split' })

vim.keymap.set('n', '<leader>s',  '<C-w>s',  { desc = 'Split horizontal' })
vim.keymap.set('n', '<leader>sv', '<C-w>v',  { desc = 'Split vertical' })
vim.keymap.set('n', '<leader>sx', '<C-w>c',  { desc = 'Close split' })
vim.keymap.set('n', '<leader>so', '<C-w>o',  { desc = 'Close other splits' })

-- ============================================================
-- FOLDS
-- ============================================================
vim.keymap.set('n', '<leader>a', 'za', { desc = 'Toggle fold' })

-- ============================================================
-- TERMINAL
-- ============================================================
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- ============================================================
-- FILETYPE: C
-- ============================================================
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'c',
    group = vim.api.nvim_create_augroup('ft-c', { clear = true }),
    callback = function()
        -- Compile and run current file (<leader>ec)
        vim.keymap.set('n', '<leader>ec',
            ':w<CR>:!gcc % -o %:r && ./%:r<CR>',
            { buffer = true, noremap = true, silent = true, desc = '[E]xecute [C] file' })

        -- Insert minimal C boilerplate (<leader>bc)
        vim.keymap.set('n', '<leader>bc',
            'i#include <stdio.h><CR><CR>int main() {<CR>}<Esc>O',
            { buffer = true, desc = '[B]oilerplate [C]' })
    end,
})

-- ============================================================
-- FILETYPE: MARKDOWN
-- ============================================================
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    group = vim.api.nvim_create_augroup('ft-markdown', { clear = true }),
    callback = function()
        -- Insert empty link with cursor on label: [|]()
        vim.keymap.set('n', '<leader>li',
            'i[]()<Left><Left><Left><Esc>a',
            { buffer = true, desc = 'MD: insert empty link' })
        -- Wrap visual selection as link label: [sel]()
        vim.keymap.set('v', '<leader>li',
            '"ac[<C-r>"]()<Esc><Left>a',
            { buffer = true, desc = 'MD: wrap selection as link label' })
        -- Insert link with clipboard as URL: [|](clipboard)
        vim.keymap.set('n', '<leader>lp',
            'i[]()<Left><Esc>pF[a',
            { buffer = true, desc = 'MD: insert link, paste URL' })
        -- Wrap visual selection as label, paste URL
        vim.keymap.set('v', '<leader>lp',
            '"ac[<C-r>"]()<Esc><Left>p',
            { buffer = true, desc = 'MD: wrap selection, paste URL' })
    end,
})

-- ============================================================
-- TABS
-- ============================================================
vim.keymap.set('n', '<leader>tn', '<cmd>tabnew<CR>',   { desc = 'Tab: new empty' })
vim.keymap.set('n', '<leader>tq', '<cmd>tabclose<CR>', { desc = 'Tab: close' })
vim.keymap.set('n', '<leader>to', '<cmd>tabonly<CR>',  { desc = 'Tab: close others' })

-- NOTE: <Tab> = <C-i> (jumplist forward) — remove if you use the jumplist
vim.keymap.set('n', '<Tab>',   '<cmd>tabnext<CR>',     { desc = 'Tab: next' })
vim.keymap.set('n', '<S-Tab>', '<cmd>tabprevious<CR>', { desc = 'Tab: prev' })

-- ============================================================
-- ZOXIDE
-- ============================================================
-- Query zoxide's ranked directory list, pick with vim.ui.select,
-- open a new tab rooted at the chosen directory.
-- vim.ui.select upgrades automatically if you add mini.pick or fzf-lua later.
vim.keymap.set('n', '<leader>z', function()
    local dirs = vim.fn.systemlist('zoxide query -l')
    if vim.v.shell_error ~= 0 or #dirs == 0 then
        vim.notify('zoxide: no results', vim.log.levels.WARN)
        return
    end
    vim.ui.select(dirs, { prompt = 'zoxide › ' }, function(choice)
        if not choice then return end
        vim.cmd('tabnew')
        vim.cmd('tcd ' .. vim.fn.fnameescape(choice))
    end)
end, { desc = 'Zoxide: jump to dir in new tab' })

-- ============================================================
-- MISC
-- ============================================================
-- Insert timestamp at cursor and drop into insert mode (<leader>c)
vim.keymap.set('n', '<leader>c', function()
    local timestamp = os.date('%I:%M %p')
    vim.api.nvim_put({ ' ' .. timestamp .. ' - ' }, 'c', false, true)
    vim.cmd('startinsert!')
end, { desc = 'Insert timestamp' })
