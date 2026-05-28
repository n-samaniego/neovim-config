-- ============================================================
-- KEYMAPS
-- ============================================================
-- Diagnostic
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', 'gl', vim.diagnostic.open_float)

-- Easier terminal escape
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Split navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- easy escape
vim.keymap.set('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })

-- not sure how much i'll use this, but it's here cuz 0 and $ aren't intuitive to me
vim.keymap.set({'n', 'v'}, 'H', '0', { desc = 'Jump to beginning of line' })
vim.keymap.set({'n', 'v'}, 'L', '$', { desc = 'Jump to end of line' })

-- Move in insert mode
vim.keymap.set("i", "<A-h>", "<Left>",  { desc = "Move left" })
vim.keymap.set("i", "<A-j>", "<Down>",  { desc = "Move down" })
vim.keymap.set("i", "<A-k>", "<Up>",    { desc = "Move up" })
vim.keymap.set("i", "<A-l>", "<Right>", { desc = "Move right" })

-- move visually in soft wrap
vim.keymap.set({'n', 'x'}, 'j', 'gj', opts)
vim.keymap.set({'n', 'x'}, 'k', 'gk', opts)
vim.keymap.set({'n', 'x'}, 'H', 'g0', opts)
vim.keymap.set({'n', 'x'}, 'L', 'g$', opts)


-- pair open and close characters
local closing_chars = { ["'"] = true, ['"'] = true, ["`"] = true,
                         [")"] = true, ["]"] = true, ["}"] = true, [">"] = true }

-- use tab to go to closing character, like helix
vim.keymap.set("i", "<Tab>", function()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local next_char = vim.api.nvim_get_current_line():sub(col + 1, col + 1)
  if closing_chars[next_char] then
    return "<Right>"
  else
    return "<Tab>"
  end
end, { expr = true, noremap = true })

-- select all
vim.keymap.set('n', '<C-a>', 'ggVG', { desc = 'Select whole file' })

-- Wrap visual selection in quotation marks or brackets
vim.keymap.set('v', '<leader>*', 'c**<Esc>P')
vim.keymap.set('v', '<leader>**', 'c****<Esc>P')
vim.keymap.set('v', "<leader>'", "c''<Esc>P")
vim.keymap.set('v', '<leader>`', 'c``<Esc>P')
vim.keymap.set('v', '<leader>"', 'c""<Esc>P')
vim.keymap.set('v', '<leader>(', 'c()<Esc>P')
vim.keymap.set('v', '<leader>)', 'c()<Esc>P')
vim.keymap.set('v', '<leader>[', 'c[]<Esc>P')
vim.keymap.set('v', '<leader>]', 'c[]<Esc>P')
vim.keymap.set('v', '<leader>{', 'c{}<Esc>P')
vim.keymap.set('v', '<leader>}', 'c{}<Esc>P')


-- clear search highlight
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- execute C code
vim.keymap.set('n', '<leader>ec', ':w<CR>:!gcc % -o %:r && ./%:r<CR>', { noremap = true, silent = true })

-- Insert C boilerplate
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.c',
  callback = function()
    vim.keymap.set('n', '<leader>bc', 'i#include <stdio.h><CR><CR>int main() {<CR>}<Esc>O', { buffer = true }, { desc = '[B]oilerplate [C]' })
  end,
})

-- Folds
vim.keymap.set("n", "<leader>a", "za", { desc = "Toggle fold" })

-- Splits
vim.keymap.set("n", "<leader>s", "<C-w>s", { desc = "Split horizontal" })
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split vertical" })
vim.keymap.set("n", "<leader>sx", "<C-w>c", { desc = "Close split" })
vim.keymap.set("n", "<leader>so", "<C-w>o", { desc = "Close other splits" })

-- markdown links
vim.keymap.set('n', '<leader>li', 'i[]()<Left><Left><Left><Esc>a', { buffer = true })
vim.keymap.set('v', '<leader>li', '"ac[<C-r>"]()<Esc><Left>a', { buffer = true })
vim.keymap.set('n', '<leader>lp', 'i[]()<Left><Esc>pF[a', { buffer = true })
vim.keymap.set('v', '<leader>lp', '"ac[<C-r>"]()<Esc><Left>p', { buffer = true })

-- timestamp
vim.keymap.set('n', '<leader>c', function()
  local timestamp = os.date("%I:%M %p")
  vim.api.nvim_put({ " " .. timestamp .. " - " }, "c", false, true)
  vim.cmd("startinsert!")
end, { buffer = true, desc = "Insert timestamp" })
