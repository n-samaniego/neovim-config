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
-- LSP
-- ============================================================
-- clangd
--vim.lsp.config('clangd', {
--    cmd = { 'clangd' },
--    filetypes = { 'c', 'cpp', 'h' },
--    root_markers = { 'compile_commands.json', 'compile_flags.txt', '.git' },
--})

-- Lua
--vim.lsp.config('lua_ls', {
--    cmd = { 'lua-language-server' },
--    filetypes = { 'lua' },
--    root_markers = { '.luarc.json', '.git' },
--    settings = {
--        Lua = {
--            runtime = { version = 'LuaJIT' },
--            workspace = {
--                checkThirdParty = false,
--                library = vim.api.nvim_get_runtime_file('', true),
--            },
--            diagnostics = { globals = { 'vim' } },
--            telemetry = { enable = false },
--        },
--    },
--})


-- Enable all of them
vim.lsp.enable({ 'clangd', 'lua_ls' })
