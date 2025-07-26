local o = vim.o

vim.g.mapleader = " "

o.laststatus = 3 -- global statusline
o.showmode = false

o.clipboard = ""

-- Indenting
o.expandtab = true
o.shiftwidth = 2
o.smartindent = true
o.tabstop = 2
o.softtabstop = 2

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = false

-- vim.opt.fillchars = { eob = " " }
o.ignorecase = true
o.smartcase = true
o.mouse = "a"

o.number = true

o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.termguicolors = true
o.timeoutlen = 400
o.undofile = true
o.cursorline = true

-- add binaries installed by mason.nvim to path
local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
vim.env.PATH = vim.env.PATH .. (is_windows and ";" or ":") .. vim.fn.stdpath("data") .. "/mason/bin"

vim.api.nvim_set_hl(0, "IndentLine", { link = "Comment" })

-- display relative line numbers in the left gutter
vim.wo.relativenumber = true

vim.opt.listchars = { nbsp = "·" }
vim.opt.list = true

vim.api.nvim_set_hl(0, "SpecialKey", { fg = "#FF0000", bg = "#00FF00" })

-- for indentmini
vim.cmd.highlight("IndentLine guifg=#333333")
vim.cmd.highlight("IndentLineCurrent guifg=#66FFFF")
