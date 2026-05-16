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
