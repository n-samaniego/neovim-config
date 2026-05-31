-- ftplugin/c.lua

vim.opt_local.colorcolumn = '80'

vim.keymap.set('n', '<leader>ec',
    ':w<CR>:!gcc -Wall -Wextra -std=c23 -pedantic % -o %:r && ./%:r<CR>',
    { buffer = true, noremap = true, silent = true, desc = '[E]xecute [C] file' })

vim.keymap.set('n', '<leader>bc',
    'i#include <stdio.h><CR><CR>int main() {<CR>}<Esc>O',
    { buffer = true, desc = '[B]oilerplate [C]' })
