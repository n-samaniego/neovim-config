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
vim.o.splitright = true
vim.o.splitbelow = true

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



-- ============================================================
-- KEYMAPS
-- ============================================================
-- Diagnostic list
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Easier terminal escape
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Split navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })

vim.keymap.set({'n', 'v'}, 'H', '0', { desc = 'Jump to beginning of line' })
vim.keymap.set({'n', 'v'}, 'L', '$', { desc = 'Jump to end of line' })

-- Move in insert mode
vim.keymap.set("i", "<A-h>", "<Left>",  { desc = "Move left" })
vim.keymap.set("i", "<A-j>", "<Down>",  { desc = "Move down" })
vim.keymap.set("i", "<A-k>", "<Up>",    { desc = "Move up" })
vim.keymap.set("i", "<A-l>", "<Right>", { desc = "Move right" })

local closing_chars = { ["'"] = true, ['"'] = true, ["`"] = true,
                         [")"] = true, ["]"] = true, ["}"] = true, [">"] = true }

vim.keymap.set("i", "<Tab>", function()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local next_char = vim.api.nvim_get_current_line():sub(col + 1, col + 1)
  if closing_chars[next_char] then
    return "<Right>"
  else
    return "<Tab>"
  end
end, { expr = true, noremap = true })


-- ============================================================
-- DIAGNOSTICS
-- ============================================================
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = true,
  virtual_lines = false,
}



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


-- ============================================================
-- Plugins
-- ============================================================
vim.pack.add({
    "https://www.github.com/nvim-tree/nvim-tree.lua",
    "https://www.github.com/echasnovski/mini.nvim",
    "https://github.com/folke/which-key.nvim",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/hrsh7th/nvim-cmp",
    "https://github.com/epwalsh/obsidian.nvim",
    "https://github.com/nvim-treesitter/nvim-treesitter-context"
--    "https://github.com/Saghen/blink.cmp"
})

local function packadd(name)
    vim.cmd("packadd " .. name)
end
packadd("nvim-tree.lua")
packadd("mini.nvim")
packadd("which-key.nvim")
packadd("plenary.nvim")
packadd("nvim-cmp")
packadd("obsidian.nvim")
packadd("nvim-treesitter-context")
-- packadd("blink.cmp")



-- ============================================================
-- Plugin Config
-- ============================================================
--nvim-tree
require("nvim-tree").setup({
    view = {
        width = 35,
    },
    filters = {
        dotfiles = false,
    },
    renderer = {
        group_empty = true,
    },
})
vim.keymap.set("n", "<leader>e", function()
    require("nvim-tree.api").tree.toggle({
    path = "<args>",
    find_file = true,
    update_root = true,
    focus = true,
    })
end, { desc = "Toggle NvimTree" })

--mini.nvim
require('mini.jump2d').setup({})
require("mini.ai").setup({})
require("mini.comment").setup({})
require("mini.move").setup({})
require("mini.surround").setup({})
require("mini.cursorword").setup({})
require("mini.indentscope").setup({})
require("mini.pairs").setup({})
require("mini.trailspace").setup({})
require("mini.bufremove").setup({})
require("mini.notify").setup({})
require("mini.icons").setup({})
-- require('mini.animate').setup({})

--which-key.nvim
local wk = require("which-key")
wk.add({
  { "<leader>f", group = "file" }, -- group
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File", mode = "n" },
  { "<leader>fb", function() print("hello") end, desc = "Foobar" },
  { "<leader>fn", desc = "New File" },
  { "<leader>f1", hidden = true }, -- hide this keymap
  { "<leader>w", proxy = "<c-w>", group = "windows" }, -- proxy to window mappings
  { "<leader>b", group = "buffers", expand = function()
      return require("which-key.extras").expand.buf()
    end
  },
  {
    -- Nested mappings are allowed and can be added in any order
    -- Most attributes can be inherited or overridden on any level
    -- There's no limit to the depth of nesting
    mode = { "n", "v" }, -- NORMAL and VISUAL mode
    { "<leader>q", "<cmd>q<cr>", desc = "Quit" }, -- no need to specify mode since it's inherited
    { "<leader>w", "<cmd>w<cr>", desc = "Write" },
  }
})

-- nvim-cmp
require("cmp").setup({})

-- obsidian.nvim
require("obsidian").setup({
    dir = "~/Documents/Codex",

    daily_notes = {
        folder = "10-19 Logs/10 Daily Notes",
        date_format = "%Y-%m-%d",
        alias_format = nil,
        default_tags = { "daily-note", "journal" }
     },

    completion = {
        nvim_cmp = true,
        min_chars = 2
    },

    open_notes_in = "current",
})

require('treesitter-context').setup({})


-- blink.cmp
-- require('blink.cmp').setup({
--     keymap = {
--         preset = 'default',  -- Tab/S-Tab to select, Enter to confirm, C-space to open
--     },
--     appearance = {
--         nerd_font_variant = 'mono',
--     },
--     sources = {
--         default = { 'lsp', 'path', 'snippets', 'buffer' },
--     },
--     completion = {
--         documentation = {
--             auto_show = true,
--             auto_show_delay_ms = 200,
--         },
--     },
--     signature = { enabled = true },   -- show function signature help while typing args
-- })



-- ============================================================
-- LSP
-- ============================================================
-- clangd
vim.lsp.config('clangd', {
    cmd = { 'clangd' },
    filetypes = { 'c', 'cpp' },
    root_markers = { 'compile_commands.json', 'compile_flags.txt', '.git' },
})

-- Lua
vim.lsp.config('lua_ls', {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { '.luarc.json', '.git' },
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file('', true),
            },
            diagnostics = { globals = { 'vim' } },
            telemetry = { enable = false },
        },
    },
})


-- Enable all of them
vim.lsp.enable({ 'clangd', 'lua_ls' })
