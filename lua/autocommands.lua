-- ============================================================
-- AUTOCOMMANDS
-- ============================================================
-- Flash yanked region
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- Leave insert mode, write the file
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
      vim.cmd("silent! write")
    end
  end,
})

-- Softwrap navigation
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "text", "typst" },
    callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set({'n', 'x'}, 'j', 'gj', opts)
        vim.keymap.set({'n', 'x'}, 'k', 'gk', opts)
        vim.keymap.set({'n', 'x'}, 'H', 'g0', opts)
        vim.keymap.set({'n', 'x'}, 'L', 'g$', opts)
    end
})
