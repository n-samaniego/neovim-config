-- ============================================================
-- LEADER (must be set before plugins)
-- ============================================================
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '



-- ============================================================
-- OPTIONS
-- ============================================================
-- UI
vim.o.number = true -- line number
vim.o.relativenumber = true -- relative line numbers
vim.o.cursorline = true -- highlight current line
vim.o.scrolloff = 999
vim.o.signcolumn = 'yes'
vim.o.showmode = false
vim.o.termguicolors = true
vim.o.wrap = true
vim.opt.linebreak = true
vim.cmd.colorscheme("monalisa")

-- Indentation
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.smartindent = true
vim.o.breakindent = true

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.inccommand = 'split'              -- live preview of substitutions

-- Splits
vim.o.splitbelow = true
vim.o.splitright = true

-- Behavior
vim.o.undofile = true
vim.o.swapfile = false
vim.o.updatetime = 250                  -- faster CursorHold (LSP hover, etc.)
vim.o.timeoutlen = 300                  -- faster keymap timeout
vim.o.confirm = true                    -- prompt to save instead of failing :q
vim.o.mouse = 'a'
vim.opt.autoread = true
vim.opt.autowrite = true
vim.opt_local.conceallevel = 1

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'       -- deferred to avoid startup latency
end)

vim.o.list = true
vim.opt.listchars = { tab = '» ',  nbsp = '␣' }

-- show trailing spaces only in normal mode
vim.api.nvim_create_autocmd('ModeChanged', {
  group = vim.api.nvim_create_augroup('listchars-mode', { clear = true }),
  callback = function()
    if vim.fn.mode() == 'n' then
      vim.opt.listchars:append({ trail = '·' })
    else
      vim.opt.listchars:remove('trail')
    end
  end,
})

-- Undo Stuff
local undodir = vim.fn.expand("~/.vim/undodir")
if
    vim.fn.isdirectory(undodir) == 0 -- creae undodir if it doesn't exist
then
    vim.fn.mkdir(undodir, "p")
end

vim.opt.undofile = true
vim.opt.undodir = undodir

-- autocomplete
vim.o.autocomplete = true
vim.opt.complete:append( 'o' )
vim.opt.completeopt = { 'menuone', 'noselect' }
vim.o.pumheight = 5
vim.o.pumborder = 'rounded'
