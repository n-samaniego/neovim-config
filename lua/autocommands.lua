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

-- fold md frontmatter
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    local first_line = vim.fn.getline(1)

    if first_line == "---" then
      vim.cmd("1,/^---$/ fold")
      vim.cmd("normal! zc")
    end
  end,
})

-- virtual text for checkboxes
local ns = vim.api.nvim_create_namespace("markdown_checkboxes")

local icons = {
  ["[ ]"] = "◯",
  ["[x]"] = "●",
  ["[-]"] = "⊘",
  ["[>]"] = "▷",
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(args)
    local bufnr = args.buf

    vim.opt_local.conceallevel = 2
    vim.opt_local.concealcursor = "nc"

    -- Conceal the actual checkbox text
    vim.fn.matchadd("Conceal", "\\[ \\]")
    vim.fn.matchadd("Conceal", "\\[x\\]")
    vim.fn.matchadd("Conceal", "\\[-\\]")
    vim.fn.matchadd("Conceal", "\\[>\\]")

    local function render()
      vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

      for row, line in ipairs(lines) do
        local dash_col, _, checkbox =
          line:find("%- (%[[ x%->]%])")

        if dash_col and checkbox and icons[checkbox] then
          vim.api.nvim_buf_set_extmark(bufnr, ns, row - 1, dash_col - 1, {
            virt_text = {
              { icons[checkbox], "Conceal" },
            },
            virt_text_pos = "overlay",
            hl_mode = "combine",
          })
        end
      end
    end

    render()

    vim.api.nvim_create_autocmd({
      "TextChanged",
      "TextChangedI",
    }, {
      buffer = bufnr,
      callback = render,
    })
  end,
})
