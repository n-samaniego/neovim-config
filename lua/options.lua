-- ============================================================
-- LEADER (must be set before plugins load)
-- ============================================================
vim.g.mapleader      = ' '
vim.g.maplocalleader = ' '

-- ============================================================
-- APPEARANCE
-- ============================================================
vim.o.number         = true             -- absolute line number on current line
vim.o.relativenumber = true             -- relative numbers on all other lines
vim.o.cursorline     = true             -- highlight the current line
vim.o.scrolloff      = 999              -- keep cursor vertically centered
vim.o.signcolumn     = 'yes'            -- always show sign column (prevents layout shift)
vim.o.showmode       = false            -- redundant with a statusline plugin
vim.o.showtabline = 1                   -- show tabline when multiple tabs
vim.o.termguicolors  = true             -- 24-bit color (disabled for monalisa theme; kept for plugins)
vim.cmd.colorscheme("monalisaV2")

-- ============================================================
-- WRAPPING & INDENTATION
-- ============================================================
vim.o.wrap        = true                -- soft-wrap long lines
vim.opt.linebreak = true                -- break at word boundaries, not mid-word
vim.o.breakindent = true                -- wrapped lines inherit indentation

vim.o.expandtab   = true                -- insert spaces instead of tabs
vim.o.shiftwidth  = 4                   -- spaces per indent level (>> / <<)
vim.o.tabstop     = 4                   -- visual width of a tab character
vim.o.smartindent = true                -- auto-indent on new lines

-- ============================================================
-- SEARCH & SUBSTITUTION
-- ============================================================
vim.o.ignorecase  = true                -- case-insensitive by default
vim.o.smartcase   = true                -- case-sensitive when query has uppercase
vim.o.hlsearch    = true                -- highlight all matches
vim.o.incsearch   = true                -- highlight matches as you type
	vim.o.inccommand  = 'split'             -- live preview of :s substitutions in a split

-- ============================================================
-- SPLITS
-- ============================================================
vim.o.splitbelow = true                 -- horizontal splits open below
vim.o.splitright = true                 -- vertical splits open to the right

-- ============================================================
-- COMPLETION
-- ============================================================
vim.opt.completeopt = { 'menuone', 'noselect', 'noinsert' }
vim.opt.shortmess:append("c")           -- suppress "match N of M" completion messages
vim.o.pumheight = 5                     -- max items visible in the popup menu
vim.o.pumborder = 'rounded'             -- rounded border on the popup menu
--vim.o.autocomplete = true
--vim.opt.complete:append( 'o' )

-- ============================================================
-- WHITESPACE DISPLAY
-- ============================================================
vim.o.list = true
vim.opt.listchars = { tab = '» ', nbsp = '␣' }

-- Show trailing spaces only in normal mode (they're expected mid-edit)
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

-- ============================================================
-- UNDO
-- ============================================================
local undodir = vim.fn.expand("~/.vim/undodir")
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")          -- create undodir if it doesn't exist
end
vim.opt.undofile = true                 -- persist undo history across sessions
vim.opt.undodir  = undodir

-- ============================================================
-- BEHAVIOR
-- ============================================================
vim.o.swapfile   = false                -- no swap files; rely on undo + git instead
vim.o.updatetime = 250                  -- faster CursorHold events (LSP hover, diagnostics)
vim.o.timeoutlen = 300                  -- shorter window for multi-key mappings
vim.o.confirm    = true                 -- prompt to save on :q instead of failing outright
vim.o.mouse      = 'a'                  -- mouse support in all modes
vim.opt.autoread  = true                -- reload file if changed on disk externally
vim.opt.autowrite = true                -- auto-save when switching buffers/running :make

-- Clipboard: deferred to avoid startup latency
vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'     -- sync with system clipboard
end)

-- ============================================================
-- CONCEAL
-- ============================================================
-- Global defaults; override per-buffer in ftplugin/ or autocmds as needed
vim.opt_local.conceallevel  = 2         -- hide concealed text (e.g. markdown formatting)
vim.opt_local.concealcursor = "n"       -- only conceal in normal mode; reveal on cursor
