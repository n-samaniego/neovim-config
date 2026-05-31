-- zen.lua
-- Distraction-free writing mode with centered margins and focus dimming.
-- Toggle with <leader>0
--
-- Layout:
--   [left pad buf] | [writing window] | [right pad buf]
--   Writing window = 50% of total columns
--   Padding buffers are empty, unlisted, nofile scratch buffers

local M = {}

-- ── State ────────────────────────────────────────────────────────────────────

local state = {
    active       = false,
    saved        = {},          -- vim options to restore on exit
    left_win     = nil,         -- window id of left padding buffer
    right_win    = nil,         -- window id of right padding buffer
    main_win     = nil,         -- window id of the writing window
    focus_ns     = nil,         -- extmark namespace for dimming
    focus_autocmd = nil,        -- autocmd id for cursor-move dimming
}

-- ── Helpers ───────────────────────────────────────────────────────────────────

local function save_opts()
    state.saved = {
        laststatus    = vim.o.laststatus,
        showmode      = vim.o.showmode,
        ruler         = vim.o.ruler,
        number        = vim.wo.number,
        relativenumber = vim.wo.relativenumber,
        signcolumn    = vim.wo.signcolumn,
        cmdheight     = vim.o.cmdheight,
        showtabline   = vim.o.showtabline,
        colorcolumn   = vim.wo.colorcolumn,
        scrolloff     = vim.o.scrolloff,
        wrap          = vim.wo.wrap,
        linebreak     = vim.wo.linebreak,
        list          = vim.wo.list,
    }
end

local function restore_opts()
    vim.o.laststatus      = state.saved.laststatus
    vim.o.showmode        = state.saved.showmode
    vim.o.ruler           = state.saved.ruler
    vim.wo.number         = state.saved.number
    vim.wo.relativenumber = state.saved.relativenumber
    vim.wo.signcolumn     = state.saved.signcolumn
    vim.o.cmdheight       = state.saved.cmdheight
    vim.o.showtabline     = state.saved.showtabline
    vim.wo.colorcolumn    = state.saved.colorcolumn
    vim.o.scrolloff       = state.saved.scrolloff
    vim.wo.wrap           = state.saved.wrap
    vim.wo.linebreak      = state.saved.linebreak
    vim.wo.list           = state.saved.list
end

-- Create a scratch padding buffer that is completely invisible
local function make_pad_buf()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].buftype    = 'nofile'
    vim.bo[buf].bufhidden  = 'wipe'
    vim.bo[buf].swapfile   = false
    vim.bo[buf].filetype   = ''
    vim.bo[buf].buflisted  = false
    return buf
end

-- Dress a padding window so it looks like empty space
local function dress_pad_win(win)
    vim.wo[win].number         = false
    vim.wo[win].relativenumber = false
    vim.wo[win].signcolumn     = 'no'
    vim.wo[win].foldcolumn     = '0'
    vim.wo[win].colorcolumn    = ''
    vim.wo[win].cursorline     = false
    vim.wo[win].cursorcolumn   = false
    vim.wo[win].wrap           = false
    vim.wo[win].list           = false
    vim.wo[win].statuscolumn   = ''
    vim.wo[win].fillchars = 'eob: '   -- replace ~ with a literal space
    -- Remove statusline from pad windows
    vim.wo[win].statusline     = ' '
    -- Match Normal background so pad blends in
    vim.wo[win].winhl          = 'Normal:Normal,EndOfBuffer:Normal'
end

-- ── Focus dimming ─────────────────────────────────────────────────────────────

-- Highlight group for dimmed lines (muted text color)
-- Defined once; :hi clear on colorscheme change would wipe it, so we also
-- wire a ColorScheme autocmd in setup() to re-apply.
local function ensure_dim_hl()
    vim.api.nvim_set_hl(0, 'ZenDim', {
        fg   = vim.api.nvim_get_hl(0, { name = 'Comment', link = false }).fg
              or vim.api.nvim_get_hl(0, { name = 'Normal',  link = false }).fg,
        bg   = 'NONE',
    })
end

local function apply_focus_dim(bufnr)
    if not state.focus_ns then return end

    local ns       = state.focus_ns
    local cursor   = vim.api.nvim_win_get_cursor(0)  -- {row, col}, 1-indexed row
    local cur_row  = cursor[1]
    local line_count = vim.api.nvim_buf_line_count(bufnr)

    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

    for row = 1, line_count do
        if row ~= cur_row then
            vim.api.nvim_buf_set_extmark(bufnr, ns, row - 1, 0, {
                end_row      = row - 1,
                end_col      = #vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1],
                hl_group     = 'ZenDim',
                hl_eol       = false,
                priority     = 10,
            })
        end
    end
end

local function clear_focus_dim(bufnr)
    if state.focus_ns then
        vim.api.nvim_buf_clear_namespace(bufnr, state.focus_ns, 0, -1)
    end
end

-- ── Enter / Exit ──────────────────────────────────────────────────────────────

local function enter_zen()
    save_opts()

    local total_cols   = vim.o.columns
    local writing_cols = math.floor(total_cols * 0.50)
    local pad_cols     = math.floor((total_cols - writing_cols) / 2)

    -- Strip all chrome from the current window first
    vim.o.laststatus      = 0
    vim.o.showmode        = false
    vim.o.ruler           = false
    vim.wo.number         = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn     = 'no'
    vim.o.cmdheight       = 0
    vim.o.showtabline     = 0
    vim.wo.colorcolumn    = ''
    vim.o.scrolloff       = 999     -- keep cursor vertically centered
    vim.wo.wrap           = true
    vim.wo.linebreak      = true    -- wrap at word boundaries
    vim.wo.list           = false   -- no listchars bleeding in

    state.main_win = vim.api.nvim_get_current_win()

    -- Left padding window
    local left_buf = make_pad_buf()
    vim.cmd('topleft ' .. pad_cols .. 'vsplit')
    vim.api.nvim_win_set_buf(0, left_buf)
    state.left_win = vim.api.nvim_get_current_win()
    dress_pad_win(state.left_win)

    -- Right padding window
    vim.api.nvim_set_current_win(state.main_win)
    local right_buf = make_pad_buf()
    vim.cmd('botright ' .. pad_cols .. 'vsplit')
    vim.api.nvim_win_set_buf(0, right_buf)
    state.right_win = vim.api.nvim_get_current_win()
    dress_pad_win(state.right_win)

    -- Return focus to the writing window
    vim.api.nvim_set_current_win(state.main_win)

    -- Block navigation into pad windows
    for _, win in ipairs({ state.left_win, state.right_win }) do
        vim.keymap.set('n', '<C-w>h', '<NOP>', { buffer = vim.api.nvim_win_get_buf(win), silent = true })
        vim.keymap.set('n', '<C-w>l', '<NOP>', { buffer = vim.api.nvim_win_get_buf(win), silent = true })
        vim.keymap.set('n', '<C-w><C-h>', '<NOP>', { buffer = vim.api.nvim_win_get_buf(win), silent = true })
        vim.keymap.set('n', '<C-w><C-l>', '<NOP>', { buffer = vim.api.nvim_win_get_buf(win), silent = true })
        -- Any key in a pad window jumps back to writing window
        vim.keymap.set({ 'n', 'i' }, '<LeftMouse>', function()
            vim.api.nvim_set_current_win(state.main_win)
        end, { buffer = vim.api.nvim_win_get_buf(win), silent = true })
    end

    -- ── Focus dim setup ──
    ensure_dim_hl()
    state.focus_ns = vim.api.nvim_create_namespace('zen_focus_dim')

    local bufnr = vim.api.nvim_win_get_buf(state.main_win)
    apply_focus_dim(bufnr)

    state.focus_autocmd = vim.api.nvim_create_autocmd(
        { 'CursorMoved', 'CursorMovedI', 'InsertEnter', 'InsertLeave' },
        {
            buffer   = bufnr,
            callback = function()
                apply_focus_dim(bufnr)
            end,
        }
    )

    state.active = true
end

local function exit_zen()
    -- Remove focus dimming
    local bufnr = vim.api.nvim_win_get_buf(state.main_win)
    clear_focus_dim(bufnr)
    if state.focus_autocmd then
        vim.api.nvim_del_autocmd(state.focus_autocmd)
        state.focus_autocmd = nil
    end

    -- Close pad windows (wiped buffers clean themselves up)
    for _, win in ipairs({ state.left_win, state.right_win }) do
        if win and vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
    end
    state.left_win  = nil
    state.right_win = nil

    -- Restore focus to the main window
    if state.main_win and vim.api.nvim_win_is_valid(state.main_win) then
        vim.api.nvim_set_current_win(state.main_win)
    end

    restore_opts()
    state.active = false
end

-- ── Public API ────────────────────────────────────────────────────────────────

function M.toggle()
    if state.active then
        exit_zen()
    else
        enter_zen()
    end
end

-- Call once from your init.lua / plugin setup
function M.setup()
    -- Re-apply dim highlight on colorscheme change so it survives :colorscheme
    vim.api.nvim_create_autocmd('ColorScheme', {
        callback = function()
            if state.active then ensure_dim_hl() end
        end,
    })

    vim.keymap.set('n', '<leader>0', M.toggle, { desc = 'Toggle zen mode' })
end

return M
