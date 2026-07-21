-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- hybrid line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- syntax higlighting
vim.opt.syntax = "on"

-- filetypes
vim.opt.filetype.plugin = "on"
vim.opt.filetype.indent = "on"

-- explicit filetypes
vim.filetype.add({
    extension = {
        -- at least in my projects:
        -- .h -> C
        -- .hpp -> C++
        h = "c",
        hpp = "cpp",
    },
})

-- clipboard
vim.opt.clipboard = "unnamedplus"

-- mouse
vim.opt.mouse = "niv"

-- tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.expandtab = true

-- line wrap
-- disable by default, in 99% of cases
-- lines should not reach the screen edge
-- and be explicitly broken
vim.opt.wrap = false
