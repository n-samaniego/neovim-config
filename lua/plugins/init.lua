-- ============================================================
-- Plugins
-- ============================================================
vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/nvim-treesitter/nvim-treesitter-context",
    "https://github.com/echasnovski/mini.nvim",
    "https://github.com/folke/which-key.nvim",
    "https://github.com/nvim-tree/nvim-tree.lua",
    "https://github.com/wom/womwiki"
--    "https://github.com/nvim-lua/plenary.nvim",
--    "https://github.com/hrsh7th/nvim-cmp",
--    "https://github.com/epwalsh/obsidian.nvim",
--    "https://github.com/Saghen/blink.cmp"
})

local function packadd(name)
    vim.cmd("packadd " .. name)
end
packadd("nvim-treesitter-context")
packadd("mini.nvim")
packadd("which-key.nvim")
packadd("nvim-tree.lua")
packadd("womwiki")
-- packadd("plenary.nvim")
-- packadd("nvim-cmp")
-- packadd("obsidian.nvim")
-- packadd("blink.cmp")



-- ============================================================
-- Plugin Config
-- ============================================================
-- treesitter
require('treesitter-context').setup({})


--mini.nvim
require("mini.pick").setup({})
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
})


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


-- womwiki
require("womwiki").setup({
  path = vim.fn.expand("~/Documents/Codex"),              -- Path to your wiki directory
  picker = nil,                     -- "snacks", "fzf", "mini", "telescope", or nil (auto-detect)
  default_link_style = "wikilink",  -- "markdown" or "wikilink" for new links

  completion = {
    enabled = true,           -- Enable link/tag autocompletion
    include_headings = true,  -- Offer headings in completion (file.md#heading)
    max_results = 50,         -- Maximum completion results
    cache_ttl = 300,          -- Cache expiry in seconds (also invalidated on save)
  },

  wikilinks = {
    enabled = true,       -- Support [[wikilink]] syntax
    spaces_to = "-",      -- Convert spaces: "-", "_", or nil (keep spaces)
    confirm_create = true, -- Confirm before creating new files from links
  },

  tags = {
    enabled = true,              -- Support #tags and frontmatter tags
    inline_pattern = "#([%w_-]+)", -- Lua pattern for inline tags
    use_frontmatter = true,      -- Parse YAML frontmatter for tags
  },
})

-- nvim-cmp
-- require("cmp").setup({})

-- obsidian.nvim
-- require("obsidian").setup({
--     dir = "~/Documents/Codex",
--
--     daily_notes = {
--         folder = "10-19 Logs/10 Daily Notes",
--         date_format = "%Y-%m-%d",
--         alias_format = nil,
--         default_tags = { "daily-note", "journal" }
--      },
--
--     completion = {
--         nvim_cmp = true,
--         min_chars = 2
--     },
--
--     open_notes_in = "current",
-- })



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
