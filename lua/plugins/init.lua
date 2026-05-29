-- lua/plugins/init.lua - List, add, and configure plugins
-- ============================================================
-- Plugins
-- ============================================================
vim.pack.add({
    "https://github.com/arborist-ts/arborist.nvim",
    "https://github.com/echasnovski/mini.nvim",
    "https://github.com/folke/which-key.nvim",
    "https://github.com/nvim-tree/nvim-tree.lua",
    "https://github.com/NStefan002/screenkey.nvim",
    'file://' .. os.getenv('HOME') .. '/Documents/Codex/20-29_Works/piki',
})

local function packadd(name)
    vim.cmd("packadd " .. name)
end
packadd("arborist.nvim")
packadd("mini.nvim")
packadd("which-key.nvim")
packadd("nvim-tree.lua")
packadd("screenkey.nvim")
packadd("piki")

-- ============================================================
-- Plugin Config
-- ============================================================
-- arborist
require('arborist').setup({
    perfer_wasm = true,
    compiler = "clang",
    update_cadence = "weekly",
    install_popular = true,
    disable = {
        indent = { "markdown", "markdown-inline" },
        highlight = { "markdown", "markdown-inline" },
    }
})


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
vim.keymap.set("n", "<leader><leader>", function()
    require("nvim-tree.api").tree.toggle({
    path = "<args>",
    find_file = true,
    update_root = true,
    focus = true,
    })
end, { desc = "Toggle NvimTree" })

-- screenkey
require("screenkey").setup({})

-- piki
require("piki").setup({
  path = vim.fn.expand("~/Documents/Codex"),              -- Path to your wiki directory
  picker = nil,                     -- "snacks", "fzf", "mini", "telescope", or nil (auto-detect)
  default_link_style = "wikilink",  -- "markdown" or "wikilink" for new links
  completion = {
    enabled = true,           -- Enable link/tag autocompletion
    include_headings = true,  -- Offer headings in completion (file.md#heading)
    max_results = 50,         -- Maximum completion results
    cache_ttl = 300,          -- Cache expiry in seconds (also invalidated on save)
  },
  markdown_help = true,
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
  daily = {
      path = "~/Documents/Codex/10-19_Logs/10_Daily-Notes",
      template_path = "~/Documents/Codex/00-09_Control/02_Templates/DailtNoteTemplate.md"
  }
})
