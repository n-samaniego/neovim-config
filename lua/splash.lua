-- original code taken from https://github.com/eoh-bse/minintro.nvim/tree/master

local intro_logo = {
    "<+>--------------------------------------------------------<+>",
    "    ,     ,   ,,     ,    ,,,,,   ,,,,  ,,,, ,,   ,,    ,,",
    "   '||   '|' '||'''''|  .:|''|||   ||    || '||' '||`  `||'",
    "    |`|   |   ||  .    .|'    :||  '|.  .|;  ||   |||  ;||",
    "    | '|. |   ||''|   :||      :|;  ||  |;   ||   |'|.//||",
    "    |   |,|   ||  `    '|.     |;    |||;    ||   | '|' ||",
    "   .|.   ||  .||.....|  ''|...|;      |;    .||. .|.   .||.",
    "    `     `   ``     `     ````       `      ``   `  `  ``",
    "<+>--------------------------------------------------------<+>",
	"    ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
	"    ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
	"    ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
	"    ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
	"    ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
	"    ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
    "<+>--------------------------------------------------------<+>",
    "    ░██▄    ▐█  ▄████  ▒▄████▄  ▄█▒     ▄█  ▒█  ▄██▄ ▄██▄",
    "    ▐█░▀█   █▌ ▓█   ▀  ██▒  ██▒ ▓██░   ░█▓  ██ ▓██▒▀█▀ ██▒",
    "    ▒██ ▀█  ██ ▒███    ██░  ██▒ ░▀█▄  ░▄█░  ██ ▓██    ▓██░",
    "   ░██▒  ▐▌ ▓█ ▒▓   ▄▒ ██   ██░ ░ ▓█  ▓█▀   ██ ▒██    ▒██",
    "   ░▒█▓░  ▐█▒█ ░▒████░  ████▓▒░   ▒▀█▄█▒   ░█▒ ▒██▒   ░██▒",
    "   ░ ▀ ░  ▒▀▒▀ ░░ ▒░ ░  ▒░▒░ ░    ░  ▀░    ░▓  ░ ▒░   ░  ░",
    "     ▒ ░  ░ ▒   ░ ░     ░ ▒  ░    ░  ░      ░  ░  ░      ░",
    "<+>--------------------------------------------------------<+>",
}

local PLUGIN_NAME = " <+>--- welcome to neovim ---<+>"
local DEFAULT_COLOR = "#9b1d29"
local INTRO_LOGO_HEIGHT = #intro_logo
local INTRO_LOGO_WIDTH = 55

local autocmd_group = vim.api.nvim_create_augroup(PLUGIN_NAME, {})
local highlight_ns_id = vim.api.nvim_create_namespace(PLUGIN_NAME)
local minintro_buff = -1

local function unlock_buf(buf)
	vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
end

local function lock_buf(buf)
	vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
end

local function draw_minintro(buf, logo_width, logo_height)
	local window = vim.fn.bufwinid(buf)
	if window == -1 then return end
	local screen_width = vim.api.nvim_win_get_width(window)
	local screen_height = vim.api.nvim_win_get_height(window) - vim.opt.cmdheight:get()

	local start_col = math.floor( ((screen_width - logo_width) / 2) - 5 )
	local start_row = math.floor((screen_height - logo_height) / 2)
	if (start_col < 0 or start_row < 0) then return end

	local top_space = {}
	for _ = 1, start_row do table.insert(top_space, "") end

	local col_offset_spaces = {}
	for _ = 1, start_col do table.insert(col_offset_spaces, " ") end
	local col_offset = table.concat(col_offset_spaces, '')

	local adjusted_logo = {}
	for _, line in ipairs(intro_logo) do
		table.insert(adjusted_logo, col_offset .. line)
	end

	unlock_buf(buf)
	vim.api.nvim_buf_set_lines(buf, 1, 1, true, top_space)
	vim.api.nvim_buf_set_lines(buf, start_row, start_row, true, adjusted_logo)
	lock_buf(buf)

	vim.api.nvim_buf_set_extmark(buf, highlight_ns_id, start_row, start_col, {
		end_row = start_row + INTRO_LOGO_HEIGHT,
		hl_group = "Default"
	})
end

local function create_and_set_minintro_buf(default_buff)
	local intro_buff = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(intro_buff, PLUGIN_NAME)
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = intro_buff })
	vim.api.nvim_set_option_value("buftype", "nofile", { buf = intro_buff })
	vim.api.nvim_set_option_value("filetype", "minintro", { buf = intro_buff })
	vim.api.nvim_set_option_value("swapfile", false, { buf = intro_buff })

	vim.api.nvim_set_current_buf(intro_buff)
	vim.api.nvim_buf_delete(default_buff, { force = true })

	return intro_buff
end

local function set_options()
	vim.opt_local.number = false
	vim.opt_local.relativenumber = false
	vim.opt_local.list = false
	vim.opt_local.fillchars = { eob = ' ' }
	vim.opt_local.colorcolumn = "0"
end

local function redraw()
	if not vim.api.nvim_buf_is_valid(minintro_buff) then return end
	if vim.fn.bufwinid(minintro_buff) == -1 then return end
	unlock_buf(minintro_buff)
	vim.api.nvim_buf_set_lines(minintro_buff, 0, -1, true, {})
	lock_buf(minintro_buff)
	draw_minintro(minintro_buff, INTRO_LOGO_WIDTH, INTRO_LOGO_HEIGHT)
end

local function display_minintro(payload)
	local is_dir = vim.fn.isdirectory(payload.file) == 1

	local default_buff = vim.api.nvim_get_current_buf()
	local default_buff_name = vim.api.nvim_buf_get_name(default_buff)
	local default_buff_filetype = vim.api.nvim_get_option_value("filetype", { buf = default_buff })
	if not is_dir and default_buff_name ~= "" and default_buff_filetype ~= PLUGIN_NAME then
		return
	end

	minintro_buff = create_and_set_minintro_buf(default_buff)
	set_options()

	draw_minintro(minintro_buff, INTRO_LOGO_WIDTH, INTRO_LOGO_HEIGHT)

	vim.api.nvim_create_autocmd({ "WinResized", "VimResized" }, {
		group = autocmd_group,
		callback = function()
			vim.schedule(redraw)
		end,
	})

	local ok, api = pcall(require, "nvim-tree.api")
	if ok then
		api.events.subscribe(api.events.Event.TreeOpen, function()
			vim.schedule(redraw)
		end)
		api.events.subscribe(api.events.Event.Resize, function()
			vim.schedule(redraw)
		end)
	end
end

local function setup(options)
	options = options or {}
	vim.api.nvim_set_hl(highlight_ns_id, "Default", { fg = options.color or DEFAULT_COLOR })
	vim.api.nvim_set_hl_ns(highlight_ns_id)

	vim.api.nvim_create_autocmd("VimEnter", {
		group = autocmd_group,
		callback = display_minintro,
		once = true
	})
end

return {
	setup = setup
}
