local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- mapleader key
vim.g.mapleader = " "

-- enable 24-bit RGB colour
vim.opt.termguicolors = true

-- plugins
require("lazy").setup({
    {
        "neovim/nvim-lspconfig",
        version = "*"
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        version = "*"
    },
    {
        "lewis6991/gitsigns.nvim",
        version = "*",
        opts = {}
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        version = "*",
        main = "ibl",
        opts = {}
    },
    {
        "gentoo/gentoo-syntax",
        version = "*"
    },
    {
        "nvim-tree/nvim-web-devicons",
        version = "*",
        opts = {}
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        version = "*",
        priority = 1000,
        opts = {
            flavour = "mocha",
            transparent_background = true,
            show_end_of_buffer = true,
            integrations = {
                treesitter = true,
                gitsigns = true,
                indent_blankline = {
                    enabled = true,
                    scope_color = "lavender",
                    colored_indent_levels = false
                }
            },
            compile_path = vim.fn.stdpath "cache" .. "/catppuccin",
        }
    },
    {
        "freddiehaddad/feline.nvim",
        version = "*",
        dependencies = {
            "gitsigns.nvim",
            "nvim-web-devicons"
        }
    }
})

-- treesitter module options
require("nvim-treesitter.configs").setup({
    -- auto install missing parsers
    auto_install = true,
    -- syntax highlighting
    highlight = {
        enable = true
    }
})

-- colour scheme
vim.cmd.colorscheme "catppuccin"
-- apply catppuccin them to feline
require("feline").setup({
    components = require("catppuccin.groups.integrations.feline").get()
})

-- hybrid line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- syntax higlighting
vim.opt.syntax = "on"

-- filetypes
vim.opt.filetype.plugin = "on"
vim.opt.filetype.indent = "on"

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

-- increase command height
vim.opt.cmdheight = 2

-- LSP client
local lspconfig = require("lspconfig")

-- structure:
-- lspconfig.<server>.setup({})
-- see help lspconfig-all
-- or https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
lspconfig.rust_analyzer.setup({}) -- dev-lang/rust[rust-analyzer]::gentoo
lspconfig.clangd.setup({}) -- sys-devel/clang::gentoo
lspconfig.bashls.setup({}) -- dev-util/bash-language-server::guru
lspconfig.yamlls.setup({}) -- dev-util/yaml-language-server::guru
lspconfig.lua_ls.setup({ -- dev-util/lua-language-server::guru
    settings = {
        Lua = {
            diagnostics = {
                globals = {"vim"} -- ignore for e.g. init.lua
            }
        }
    }
})
lspconfig.pyright.setup({}) -- pyright (pipx)
lspconfig.cmake.setup({}) -- cmake-language-server (pipx)
lspconfig.nginx_language_server.setup({}) -- nginx-language-server (pipx)

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end
})
