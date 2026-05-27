-- monalisaV2.lua
-- A Neovim colorscheme based on the MonaLisa terminal palette.
-- V2: Semantic layer redesign — prose / variable / type / keyword / literal hierarchy.

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end
vim.g.colors_name = "monalisaV2"

-- ── Palette ──────────────────────────────────────────────────────────────────
-- Normal (dim) variants
local c0  = "#421e0b"  -- black        (deep brown-black)
local c1  = "#9b291c"  -- red          (muted crimson)
local c2  = "#636232"  -- green        (olive)
local c3  = "#c36e28"  -- yellow       (amber/orange)
local c4  = "#617b83"  -- blue         (slate teal — types/structs/interfaces)
local c5  = "#9b1d29"  -- magenta      (deep rose)
local c6  = "#588056"  -- cyan         (muted sage)
local c7  = "#f7d75c"  -- white        (warm yellow-white)

-- Bright variants
local c8  = "#874228"  -- bright black (warm brown-gray)
local c9  = "#ff4331"  -- bright red
local c10 = "#9eb2b4"  -- bright green (yellow-green)
local c11 = "#ff9566"  -- bright yellow (peach/orange)
local c12 = "#bfb687"  -- bright blue  (dusty parchment — variables/identifiers/parameters)
local c13 = "#C9A0DC"  -- bright magenta (coral pink)
local c14 = "#8acd8f"  -- bright cyan  (mint green)
local c15 = "#ffe598"  -- bright white (cream)

-- Special
local bg        = "#120b0d"  -- background (near-black with warm tint)
local fg        = "#e6c86f"  -- foreground (parchment golden — calmer, less saturated)
local cursor_bg = "#c36c32"  -- cursor color (engraved bronze — strings, brackets)

-- Derived surface colors — interpolated between bg and c0/c8 for layering
local bg1 = "#1e1010"  -- slightly lighter than bg (sidebars, cursorline)
local bg2 = c0  -- gutters, popups
local bg3 = "#3a1e12"  -- visual selection, match bg
local bg4 = "#5a3520"  -- borders, faint UI chrome

-- Semantic aliases
local red    = c9    -- bright red    — errors, keywords
local green  = c6    -- bright cyan/mint — strings, functions
local yellow = c7    -- warm yellow   — types, warnings
local blue   = c12   -- parchment tan  — identifiers, tags (now dusty parchment)
local purple = c13   -- coral pink    — constants, booleans
local aqua   = c14   -- mint          -- preprocessor, structure
local orange = c11   -- peach/orange  — operators, storage, special

local n_red    = c1   -- neutral/dim variants for sign column
local n_green  = c6
local n_yellow = c3
local n_blue   = c4   -- now slate teal — architectural layer
local n_purple = c5
local n_aqua   = c6
local n_orange = c3

local gray     = c8   -- comments, fold text, subtle UI
local fg0      = c15  -- brightest foreground (rarely used)
local fg1      = fg   -- primary foreground
local fg2      = "#d4b55c"  -- slightly dimmer fg
local fg3      = "#b89840"  -- dimmer still — delimiters
local fg4      = c0  -- faintest fg — line numbers, subtle text

-- ── Helper ───────────────────────────────────────────────────────────────────
local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- ── Terminal Colors ───────────────────────────────────────────────────────────
vim.g.terminal_color_0  = c0
vim.g.terminal_color_1  = n_red
vim.g.terminal_color_2  = n_green
vim.g.terminal_color_3  = n_yellow
vim.g.terminal_color_4  = n_blue
vim.g.terminal_color_5  = n_purple
vim.g.terminal_color_6  = n_aqua
vim.g.terminal_color_7  = fg4
vim.g.terminal_color_8  = gray
vim.g.terminal_color_9  = red
vim.g.terminal_color_10 = green
vim.g.terminal_color_11 = yellow
vim.g.terminal_color_12 = blue
vim.g.terminal_color_13 = purple
vim.g.terminal_color_14 = aqua
vim.g.terminal_color_15 = fg1

-- ── Named Highlight Groups ────────────────────────────────────────────────────
-- These mirror gruvbox's intermediate groups so filetype links below work.
hl("MonaLisaFg0",        { fg = fg0 })
hl("MonaLisaFg1",        { fg = fg1 })
hl("MonaLisaFg2",        { fg = fg2 })
hl("MonaLisaFg3",        { fg = fg3 })
hl("MonaLisaFg4",        { fg = fg4 })
hl("MonaLisaGray",       { fg = gray })
hl("MonaLisaBg0",        { fg = bg })
hl("MonaLisaBg1",        { fg = bg1 })
hl("MonaLisaBg2",        { fg = bg2 })
hl("MonaLisaBg3",        { fg = bg3 })
hl("MonaLisaBg4",        { fg = bg4 })

hl("MonaLisaRed",        { fg = red })
hl("MonaLisaRedBold",    { fg = red,    bold = true })
hl("MonaLisaGreen",      { fg = green })
hl("MonaLisaGreenBold",  { fg = green,  bold = true })
hl("MonaLisaYellow",     { fg = yellow })
hl("MonaLisaYellowBold", { fg = yellow, bold = true })
hl("MonaLisaBlue",       { fg = blue })
hl("MonaLisaBlueBold",   { fg = blue })
hl("MonaLisaPurple",     { fg = purple })
hl("MonaLisaPurpleBold", { fg = purple, bold = true })
hl("MonaLisaAqua",       { fg = aqua })
hl("MonaLisaAquaBold",   { fg = aqua,   bold = true })
hl("MonaLisaOrange",     { fg = orange })
hl("MonaLisaOrangeBold", { fg = orange })

-- Sign column variants (fg = color, bg = bg2 i.e. gutter bg)
hl("MonaLisaRedSign",    { fg = red,    bg = bg })
hl("MonaLisaGreenSign",  { fg = green,  bg = bg })
hl("MonaLisaYellowSign", { fg = yellow, bg = bg })
hl("MonaLisaBlueSign",   { fg = blue,   bg = bg })
hl("MonaLisaPurpleSign", { fg = purple, bg = bg })
hl("MonaLisaAquaSign",   { fg = aqua,   bg = bg })
hl("MonaLisaOrangeSign", { fg = orange, bg = bg })

-- ── General UI ────────────────────────────────────────────────────────────────
hl("Normal",       { fg = fg1,  bg = bg })
hl("NormalFloat",  { fg = fg1,  bg = bg2 })
hl("NormalNC",     { fg = fg2,  bg = bg })

hl("CursorLine",   { bg = bg1 })
hl("CursorColumn", { link = "CursorLine" })
hl("CursorLineNr", { fg = yellow, bg = bg1 })
hl("LineNr",       { fg = fg4 })

hl("ColorColumn",  { bg = bg1 })
hl("Conceal",      { fg = blue })
hl("MatchParen",   { bg = bg3,  bold = true })

hl("TabLineFill",  { fg = fg4,  bg = bg1 })
hl("TabLineSel",   { fg = green, bg = bg1 })
hl("TabLine",      { link = "TabLineFill" })

hl("Visual",       { bg = bg3 })
hl("VisualNOS",    { link = "Visual" })

hl("Search",       { fg = cursor_bg, bg = bg,  reverse = true })
hl("IncSearch",    { fg = blue, bg = bg, reverse = true })
hl("CurSearch",    { link = "IncSearch" })

hl("Underlined",   { fg = blue, underline = true })

hl("StatusLine",   { fg = fg1, bg = bg1, reverse = false })
hl("StatusLineNC", { fg = fg1, bg = bg1, reverse = false })

hl("VertSplit",    { fg = bg3, bg = bg })
hl("WinSeparator", { link = "VertSplit" })

hl("WildMenu",     { fg = blue, bg = bg2, bold = true })
hl("Pmenu",        { fg = fg1, bg = bg2 })
hl("PmenuSel",     { fg = bg2, bg = blue, bold = true })
hl("PmenuSbar",    { bg = bg2 })
hl("PmenuThumb",   { bg = fg4 })

hl("Directory",    { link = "MonaLisaGreenBold" })
hl("Title",        { link = "MonaLisaGreenBold" })

hl("ErrorMsg",     { fg = bg,  bg = red, bold = true })
hl("MoreMsg",      { link = "MonaLisaYellowBold" })
hl("ModeMsg",      { link = "MonaLisaYellowBold" })
hl("Question",     { link = "MonaLisaOrangeBold" })
hl("WarningMsg",   { link = "MonaLisaRedBold" })

hl("NonText",      { link = "MonaLisaBg2" })
hl("SpecialKey",   { link = "Comment" })

-- ── Gutter ────────────────────────────────────────────────────────────────────
hl("SignColumn",   { bg = bg })
hl("Folded",       { fg = gray, bg = bg1, italic = true })
hl("FoldColumn",   { fg = gray, bg = bg1 })

-- ── Cursor ────────────────────────────────────────────────────────────────────
hl("Cursor",   { fg = bg, bg = cursor_bg })
hl("vCursor",  { link = "Cursor" })
hl("iCursor",  { link = "Cursor" })
hl("lCursor",  { link = "Cursor" })

-- ── Syntax ────────────────────────────────────────────────────────────────────
hl("Comment",      { fg = gray, italic = true })
hl("Todo",         { bold = true, italic = true })
hl("Error",        { fg = red, bold = true, reverse = true })

hl("Special",      { link = "MonaLisaOrange" })

hl("Statement",    { fg = c5 })
hl("Conditional",  { fg = c5 })
hl("Repeat",       { fg = c5 })
hl("Label",        { link = "MonaLisaRed" })
hl("Exception",    { fg = c5 })
hl("Keyword",      { fg = c5 })
hl("Operator",     { link = "Normal" })

hl("Identifier",   { fg = c12 })
hl("Function",     { link = "MonaLisaGreen" })

hl("PreProc",      { fg = c1 })
hl("Include",      { link = "MonaLisaAqua" })
hl("Define",       { fg = c1 })
hl("Macro",        { fg = c1 })
hl("PreCondit",    { link = "MonaLisaAqua" })

hl("Constant",     { link = "MonaLisaPurple" })
hl("Character",    { fg = c11 })
hl("Boolean",      { link = "MonaLisaPurple" })
hl("Number",       { link = "MonaLisaPurple" })
hl("Float",        { link = "MonaLisaPurple" })
hl("String",       { fg = c11 })

hl("Type",         { fg = c4 })
hl("StorageClass", { fg = c1 })
hl("Structure",    { link = "MonaLisaAqua" })
hl("Typedef",      { fg = c4 })

-- ── Spelling ──────────────────────────────────────────────────────────────────
hl("SpellBad",   { undercurl = true, sp = blue })
hl("SpellCap",   { undercurl = true, sp = red })
hl("SpellLocal", { undercurl = true, sp = aqua })
hl("SpellRare",  { undercurl = true, sp = purple })

-- ── Diffs ─────────────────────────────────────────────────────────────────────
hl("DiffAdd",    { fg = green,  bg = bg, reverse = true })
hl("DiffDelete", { fg = red,    bg = bg, reverse = true })
hl("DiffChange", { fg = aqua,   bg = bg, reverse = true })
hl("DiffText",   { fg = yellow, bg = bg, reverse = true })

-- ── Treesitter ────────────────────────────────────────────────────────────────
-- These capture names are the modern standard; older @xxx.yyy names link too.
hl("@comment",              { link = "Comment" })
hl("@keyword",              { fg = c5 })
hl("@keyword.return",       { fg = c5 })
hl("@keyword.function",     { link = "MonaLisaAqua" })
hl("@keyword.operator",     { fg = red })
hl("@conditional",          { fg = c5 })
hl("@repeat",               { fg = c5 })
hl("@include",              { link = "Include" })
hl("@exception",            { link = "Exception" })
hl("@operator",             { link = "Operator" })
hl("@punctuation",          { fg = fg3 })
hl("@punctuation.bracket",  { fg = "#c36c32" })
hl("@punctuation.delimiter",{ fg = fg3 })

hl("@variable",             { fg = c12 })
hl("@variable.builtin",     { fg = orange })
hl("@variable.parameter",   { fg = c12 })
hl("@variable.member",      { fg = c10 })

hl("@function",             { link = "Function" })
hl("@function.call",        { link = "Function" })
hl("@function.builtin",     { fg = orange })
hl("@function.macro",       { link = "MonaLisaAqua" })
hl("@method",               { link = "Function" })
hl("@method.call",          { link = "Function" })
hl("@constructor",          { fg = yellow })

hl("@type",                 { link = "Type" })
hl("@type.builtin",         { fg = yellow })
hl("@type.qualifier",       { link = "StorageClass" })
hl("@type.definition",      { fg = c4 })

hl("@namespace",            { fg = aqua })
hl("@module",               { fg = aqua })

hl("@constant",             { link = "Constant" })
hl("@constant.builtin",     { link = "Constant" })
hl("@constant.macro",       { link = "Define" })

hl("@string",               { link = "String" })
hl("@string.escape",        { fg = c3 })
hl("@string.special",       { fg = c3 })
hl("@character",            { fg = cursor_bg })
hl("@number",               { link = "Number" })
hl("@float",                { link = "Float" })
hl("@boolean",              { link = "Boolean" })

hl("@label",                { link = "Label" })
hl("@tag",                  { fg = blue })
hl("@tag.attribute",        { fg = aqua })
hl("@tag.delimiter",        { fg = fg3 })

hl("@attribute",            { fg = aqua })
hl("@property",             { fg = fg1 })

hl("@preproc",              { fg = c1 })
hl("@define",               { fg = c1 })
hl("@macro",                { fg = c1 })

hl("@text",                 { fg = fg1 })
hl("@text.strong",          { bold = true })
hl("@text.italic",          { italic = true })
hl("@text.underline",       { underline = true })
hl("@text.uri",             { fg = purple, underline = true })
hl("@text.reference",       { fg = gray, underline = true })
hl("@text.title",           { link = "MonaLisaGreenBold" })
hl("@text.literal",         { link = "MonaLisaAqua" })

hl("@markup.strong",        { bold = true })
hl("@markup.italic",        { italic = true })
hl("@markup.underline",     { underline = true })
hl("@markup.heading",       { link = "MonaLisaGreenBold" })
hl("@markup.heading.1",     { link = "markdownH1" })
hl("@markup.heading.2",     { link = "markdownH2" })
hl("@markup.heading.3",     { link = "markdownH3" })
hl("@markup.link",          { fg = gray, underline = true })
hl("@markup.link.url",      { fg = purple, underline = true })
hl("@markup.raw",           { link = "MonaLisaAqua" })
hl("@markup.list",          { fg = gray })

-- ── LSP Semantic Tokens ───────────────────────────────────────────────────────
hl("@lsp.type.class",         { fg = c4 })
hl("@lsp.type.comment",       { link = "Comment" })
hl("@lsp.type.decorator",     { fg = c1 })
hl("@lsp.type.enum",          { fg = c4 })
hl("@lsp.type.enumMember",    { link = "MonaLisaPurple" })
hl("@lsp.type.function",      { link = "Function" })
hl("@lsp.type.interface",     { fg = c4 })
hl("@lsp.type.macro",         { fg = c1 })
hl("@lsp.type.method",        { link = "Function" })
hl("@lsp.type.namespace",     { link = "MonaLisaAqua" })
hl("@lsp.type.parameter",     { fg = c12 })
hl("@lsp.type.property",      { fg = c10 })
hl("@lsp.type.struct",        { fg = c4 })
hl("@lsp.type.type",          { fg = c4 })
hl("@lsp.type.typeParameter", { fg = c4 })
hl("@lsp.type.variable",      { fg = c12 })

-- ── LSP Diagnostics ───────────────────────────────────────────────────────────
hl("DiagnosticError",            { fg = red })
hl("DiagnosticWarn",             { fg = yellow })
hl("DiagnosticInfo",             { fg = blue })
hl("DiagnosticHint",             { fg = aqua })
hl("DiagnosticOk",               { fg = green })
hl("DiagnosticUnderlineError",   { undercurl = true, sp = red })
hl("DiagnosticUnderlineWarn",    { undercurl = true, sp = yellow })
hl("DiagnosticUnderlineInfo",    { undercurl = true, sp = blue })
hl("DiagnosticUnderlineHint",    { undercurl = true, sp = aqua })
hl("DiagnosticSignError",        { link = "MonaLisaRedSign" })
hl("DiagnosticSignWarn",         { link = "MonaLisaYellowSign" })
hl("DiagnosticSignInfo",         { link = "MonaLisaBlueSign" })
hl("DiagnosticSignHint",         { link = "MonaLisaAquaSign" })
hl("DiagnosticFloatingError",    { link = "MonaLisaRed" })
hl("DiagnosticFloatingWarn",     { link = "MonaLisaYellow" })
hl("DiagnosticFloatingInfo",     { link = "MonaLisaBlue" })
hl("DiagnosticFloatingHint",     { link = "MonaLisaAqua" })
hl("DiagnosticVirtualTextError", { fg = red,    bg = bg1 })
hl("DiagnosticVirtualTextWarn",  { fg = yellow, bg = bg1 })
hl("DiagnosticVirtualTextInfo",  { fg = blue,   bg = bg1 })
hl("DiagnosticVirtualTextHint",  { fg = aqua,   bg = bg1 })

-- ── Git / Diff Signs ──────────────────────────────────────────────────────────
hl("GitGutterAdd",          { link = "MonaLisaGreenSign" })
hl("GitGutterChange",       { link = "MonaLisaAquaSign" })
hl("GitGutterDelete",       { link = "MonaLisaRedSign" })
hl("GitGutterChangeDelete", { link = "MonaLisaAquaSign" })
hl("SignifySignAdd",         { link = "MonaLisaGreenSign" })
hl("SignifySignChange",      { link = "MonaLisaAquaSign" })
hl("SignifySignDelete",      { link = "MonaLisaRedSign" })
hl("gitcommitSelectedFile",  { link = "MonaLisaGreen" })
hl("gitcommitDiscardedFile", { link = "MonaLisaRed" })

-- ── Diff (file) ───────────────────────────────────────────────────────────────
hl("diffAdded",   { link = "MonaLisaGreen" })
hl("diffRemoved", { link = "MonaLisaRed" })
hl("diffChanged", { link = "MonaLisaAqua" })
hl("diffFile",    { link = "MonaLisaOrange" })
hl("diffNewFile", { link = "MonaLisaYellow" })
hl("diffLine",    { link = "MonaLisaBlue" })

-- ── File Browsers ─────────────────────────────────────────────────────────────
hl("netrwDir",      { link = "MonaLisaAqua" })
hl("netrwClassify", { link = "MonaLisaAqua" })
hl("netrwLink",     { link = "MonaLisaGray" })
hl("netrwSymLink",  { link = "MonaLisaFg1" })
hl("netrwExe",      { link = "MonaLisaYellow" })
hl("netrwComment",  { link = "MonaLisaGray" })
hl("netrwList",     { link = "MonaLisaBlue" })
hl("netrwHelpCmd",  { link = "MonaLisaAqua" })
hl("netrwCmdSep",   { link = "MonaLisaFg3" })
hl("netrwVersion",  { link = "MonaLisaGreen" })

hl("NERDTreeDir",       { link = "MonaLisaAqua" })
hl("NERDTreeDirSlash",  { link = "MonaLisaAqua" })
hl("NERDTreeOpenable",  { link = "MonaLisaOrange" })
hl("NERDTreeClosable",  { link = "MonaLisaOrange" })
hl("NERDTreeFile",      { link = "MonaLisaFg1" })
hl("NERDTreeExecFile",  { link = "MonaLisaYellow" })
hl("NERDTreeUp",        { link = "MonaLisaGray" })
hl("NERDTreeCWD",       { link = "MonaLisaGreen" })
hl("NERDTreeHelp",      { link = "MonaLisaFg1" })
hl("NERDTreeToggleOn",  { link = "MonaLisaGreen" })
hl("NERDTreeToggleOff", { link = "MonaLisaRed" })

-- ── Telescope ─────────────────────────────────────────────────────────────────
hl("TelescopeNormal",         { fg = fg1, bg = bg2 })
hl("TelescopeBorder",         { fg = bg4, bg = bg2 })
hl("TelescopePromptNormal",   { fg = fg1, bg = bg1 })
hl("TelescopePromptBorder",   { fg = bg4, bg = bg1 })
hl("TelescopePromptTitle",    { fg = bg, bg = orange, bold = true })
hl("TelescopePreviewTitle",   { fg = bg, bg = green, bold = true })
hl("TelescopeResultsTitle",   { fg = bg4, bg = bg2 })
hl("TelescopeSelection",      { fg = fg1, bg = bg3 })
hl("TelescopeSelectionCaret", { fg = orange, bg = bg3 })
hl("TelescopeMatching",       { fg = yellow, bold = true })

-- ── Markdown ──────────────────────────────────────────────────────────────────
hl("markdownItalic",             { fg = fg3, italic = true })
hl("markdownH1",                 { fg = "#515c5d", bold = true })
hl("markdownH2",                 { fg = c2, bold = true })
hl("markdownH3",                 { fg = "#7b6a52", bold = true })
hl("markdownH4",                 { link = "MonaLisaYellowBold" })
hl("markdownH5",                 { link = "MonaLisaYellow" })
hl("markdownH6",                 { link = "MonaLisaYellow" })
hl("markdownCode",               { link = "MonaLisaAqua" })
hl("markdownCodeBlock",          { link = "MonaLisaAqua" })
hl("markdownCodeDelimiter",      { link = "MonaLisaAqua" })
hl("markdownBlockquote",         { link = "MonaLisaGray" })
hl("markdownListMarker",         { link = "MonaLisaGray" })
hl("markdownOrderedListMarker",  { link = "MonaLisaGray" })
hl("markdownRule",               { link = "MonaLisaGray" })
hl("markdownHeadingRule",        { link = "MonaLisaGray" })
hl("markdownUrlDelimiter",       { link = "MonaLisaFg3" })
hl("markdownLinkDelimiter",      { link = "MonaLisaFg3" })
hl("markdownLinkTextDelimiter",  { link = "MonaLisaFg3" })
hl("markdownHeadingDelimiter",   { link = "MonaLisaOrange" })
hl("markdownUrl",                { link = "MonaLisaPurple" })
hl("markdownUrlTitleDelimiter",  { link = "MonaLisaGreen" })
hl("markdownLinkText",           { fg = gray, underline = true })
hl("markdownIdDeclaration",      { link = "markdownLinkText" })

-- ── HTML ──────────────────────────────────────────────────────────────────────
hl("htmlTag",             { link = "MonaLisaBlue" })
hl("htmlEndTag",          { link = "MonaLisaBlue" })
hl("htmlTagName",         { link = "MonaLisaAquaBold" })
hl("htmlArg",             { link = "MonaLisaAqua" })
hl("htmlScriptTag",       { link = "MonaLisaPurple" })
hl("htmlTagN",            { link = "MonaLisaFg1" })
hl("htmlSpecialTagName",  { link = "MonaLisaAquaBold" })
hl("htmlLink",            { fg = fg4, underline = true })
hl("htmlSpecialChar",     { link = "MonaLisaOrange" })
hl("htmlBold",            { bold = true })
hl("htmlItalic",          { italic = true })
hl("htmlUnderline",       { underline = true })

-- ── XML ───────────────────────────────────────────────────────────────────────
hl("xmlTag",               { link = "MonaLisaBlue" })
hl("xmlEndTag",            { link = "MonaLisaBlue" })
hl("xmlTagName",           { link = "MonaLisaBlue" })
hl("xmlEqual",             { link = "MonaLisaBlue" })
hl("xmlAttrib",            { link = "MonaLisaAqua" })
hl("xmlProcessingDelim",   { link = "MonaLisaGray" })
hl("xmlEntity",            { link = "MonaLisaOrange" })
hl("xmlEntityPunct",       { link = "MonaLisaOrange" })

-- ── CSS ───────────────────────────────────────────────────────────────────────
hl("cssIdentifier",  { link = "MonaLisaOrange" })
hl("cssClassName",   { link = "MonaLisaGreen" })
hl("cssColor",       { link = "MonaLisaBlue" })
hl("cssSelectorOp",  { link = "MonaLisaBlue" })
hl("cssSelectorOp2", { link = "MonaLisaBlue" })
hl("cssImportant",   { link = "MonaLisaGreen" })
hl("cssValueLength", { link = "MonaLisaBlue" })
hl("cssValueInteger",{ link = "MonaLisaBlue" })
hl("cssValueNumber", { link = "MonaLisaBlue" })
hl("cssValueAngle",  { link = "MonaLisaBlue" })
hl("cssValueTime",   { link = "MonaLisaBlue" })
hl("cssValueFrequency",{ link = "MonaLisaBlue" })
hl("cssVendor",      { link = "MonaLisaFg1" })
hl("cssNthArgument", { link = "MonaLisaOrange" })
hl("cssUnitDecorators",{ link = "MonaLisaOrange" })
hl("cssAttrComma",   { link = "MonaLisaFg1" })
hl("cssBraces",      { link = "MonaLisaFg1" })
hl("cssClassNameDot",{ link = "MonaLisaFg1" })
hl("cssMediaType",   { link = "MonaLisaOrange" })

-- ── JavaScript ────────────────────────────────────────────────────────────────
hl("javaScriptBraces",  { link = "MonaLisaFg1" })
hl("javaScriptFunction",{ link = "MonaLisaAqua" })
hl("javaScriptIdentifier",{ link = "MonaLisaRed" })
hl("javaScriptMember",  { link = "MonaLisaBlue" })
hl("javaScriptNumber",  { link = "MonaLisaPurple" })
hl("javaScriptNull",    { link = "MonaLisaPurple" })
hl("javaScriptParens",  { link = "MonaLisaFg3" })

-- ── TypeScript ────────────────────────────────────────────────────────────────
hl("typeScriptReserved",   { link = "MonaLisaAqua" })
hl("typeScriptLabel",      { link = "MonaLisaAqua" })
hl("typeScriptFuncKeyword",{ link = "MonaLisaAqua" })
hl("typeScriptIdentifier", { link = "MonaLisaOrange" })
hl("typeScriptBraces",     { link = "MonaLisaFg1" })
hl("typeScriptNull",       { link = "MonaLisaPurple" })
hl("typeScriptInterpolationDelimiter",{ link = "MonaLisaAqua" })

-- ── Lua ───────────────────────────────────────────────────────────────────────
hl("luaIn",       { link = "MonaLisaRed" })
hl("luaFunction", { link = "MonaLisaAqua" })
hl("luaTable",    { link = "MonaLisaOrange" })

-- ── C / C++ ───────────────────────────────────────────────────────────────────
hl("cOperator",   { link = "MonaLisaPurple" })
hl("cStructure",  { link = "MonaLisaYellow" })

-- ── Go ────────────────────────────────────────────────────────────────────────
hl("goDirective",   { link = "MonaLisaAqua" })
hl("goConstants",   { link = "MonaLisaPurple" })
hl("goDeclaration", { link = "MonaLisaRed" })
hl("goDeclType",    { link = "MonaLisaBlue" })
hl("goBuiltins",    { link = "MonaLisaOrange" })

-- ── Python ────────────────────────────────────────────────────────────────────
hl("pythonBuiltin",       { link = "MonaLisaOrange" })
hl("pythonBuiltinObj",    { link = "MonaLisaOrange" })
hl("pythonBuiltinFunc",   { link = "MonaLisaOrange" })
hl("pythonFunction",      { link = "MonaLisaAqua" })
hl("pythonDecorator",     { link = "MonaLisaRed" })
hl("pythonInclude",       { link = "MonaLisaBlue" })
hl("pythonImport",        { link = "MonaLisaBlue" })
hl("pythonRun",           { link = "MonaLisaBlue" })
hl("pythonCoding",        { link = "MonaLisaBlue" })
hl("pythonOperator",      { link = "MonaLisaRed" })
hl("pythonExceptions",    { link = "MonaLisaPurple" })
hl("pythonBoolean",       { link = "MonaLisaPurple" })
hl("pythonDot",           { link = "MonaLisaFg3" })
hl("pythonConditional",   { link = "MonaLisaRed" })
hl("pythonRepeat",        { link = "MonaLisaRed" })
hl("pythonDottedName",    { link = "MonaLisaGreenBold" })

-- ── Rust ──────────────────────────────────────────────────────────────────────
hl("rustSelf",          { link = "MonaLisaBlue" })
hl("rustPanic",         { link = "MonaLisaOrange" })
hl("rustAssert",        { link = "MonaLisaBlue" })
hl("rustDerive",        { link = "MonaLisaBlue" })
hl("rustEnumVariant",   { link = "MonaLisaPurple" })
hl("rustLifetime",      { link = "MonaLisaBlue" })
hl("rustMacro",         { link = "MonaLisaAqua" })
hl("rustModPath",       { link = "MonaLisaAqua" })
hl("rustCommentLine",   { link = "Comment" })
hl("rustKeyword",       { link = "MonaLisaRed" })

-- ── JSON ──────────────────────────────────────────────────────────────────────
hl("jsonKeyword", { link = "MonaLisaGreen" })
hl("jsonQuote",   { link = "MonaLisaGreen" })
hl("jsonBraces",  { link = "MonaLisaFg1" })
hl("jsonString",  { link = "MonaLisaFg1" })

-- ── Vimscript ─────────────────────────────────────────────────────────────────
hl("vimCommentTitle", { fg = fg4, bold = true, italic = true })
hl("vimNotation",     { link = "MonaLisaOrange" })
hl("vimBracket",      { link = "MonaLisaOrange" })
hl("vimMapModKey",    { link = "MonaLisaOrange" })
hl("vimFuncSID",      { link = "MonaLisaFg3" })
hl("vimSetSep",       { link = "MonaLisaFg3" })
hl("vimSep",          { link = "MonaLisaFg3" })
hl("vimContinue",     { link = "MonaLisaFg3" })

-- ── Ruby ──────────────────────────────────────────────────────────────────────
hl("rubyStringDelimiter",      { link = "MonaLisaGreen" })
hl("rubyInterpolationDelimiter",{ link = "MonaLisaAqua" })

-- ── Elixir ────────────────────────────────────────────────────────────────────
hl("elixirDocString",           { link = "Comment" })
hl("elixirStringDelimiter",     { link = "MonaLisaGreen" })
hl("elixirInterpolationDelimiter",{ link = "MonaLisaAqua" })
hl("elixirModuleDeclaration",   { link = "MonaLisaYellow" })
