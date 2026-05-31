-- ftplugin/markdown.lua

-- ── Options ────────────────────────────────────────────────────────────────
vim.opt_local.conceallevel  = 2
vim.opt_local.concealcursor = 'nc'
vim.opt_local.tabstop      = 2
vim.opt_local.shiftwidth   = 2
vim.opt_local.expandtab    = true  -- insert spaces, not a tab character

-- ── Keymaps ────────────────────────────────────────────────────────────────
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

-- ── Checkbox virtual text ───────────────────────────────────────────────────
local checkbox_ns = vim.api.nvim_create_namespace('markdown_checkboxes')
local checkbox_icons = {
    ['[ ]'] = '◯',
    ['[x]'] = '●',
    ['[-]'] = '⊘',
    ['[>]'] = '▷',
}

local bufnr = vim.api.nvim_get_current_buf()

local function render_checkboxes()
    vim.api.nvim_buf_clear_namespace(bufnr, checkbox_ns, 0, -1)
    for row, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
        local dash_col, end_col, checkbox = line:find('%- (%[[ x%->]%])')
        if dash_col and checkbox and checkbox_icons[checkbox] then
            vim.api.nvim_buf_set_extmark(bufnr, checkbox_ns, row - 1, dash_col - 1, {
                end_col = dash_col + 1,
                conceal = '',
            })
            local bracket_col = dash_col + 2
            vim.api.nvim_buf_set_extmark(bufnr, checkbox_ns, row - 1, bracket_col - 1, {
                end_col = end_col,
                conceal = checkbox_icons[checkbox],
            })
        end
    end
end

render_checkboxes()

vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
    buffer   = bufnr,
    callback = render_checkboxes,
})

-- ── YAML frontmatter fold ───────────────────────────────────────────────────
vim.api.nvim_create_autocmd('BufReadPost', {
    buffer   = bufnr,
    callback = function()
        if vim.fn.getline(1) == '---' then
            local ok = pcall(vim.cmd, '1,/^---$/ fold')
            if ok then
                pcall(vim.cmd, 'normal! zc')
            end
        end
    end,
})
