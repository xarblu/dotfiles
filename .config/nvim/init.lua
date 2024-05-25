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
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            {
                "dcampos/cmp-snippy",
                dependencies = {
                    {
                        "dcampos/nvim-snippy",
                        dependencies = {
                            "honza/vim-snippets"
                        }
                    }
                }
            }
        }
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        version = "*"
    },
    {
        "lewis6991/gitsigns.nvim",
        version = "*",
        config = true
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        version = "*",
        main = "ibl",
        config = true
    },
    {
        "gentoo/gentoo-syntax",
        version = "*",
        dependencies = {
            "dense-analysis/ale"
        }
    },
    {
        "nvim-tree/nvim-web-devicons",
        version = "*",
        config = true
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
                },
                noice = true,
                notify = true
            },
            compile_path = vim.fn.stdpath "cache" .. "/catppuccin",
        },
        init = function()
            vim.cmd.colorscheme "catppuccin"
        end
    },
    {
        "freddiehaddad/feline.nvim",
        dependencies = {
            "gitsigns.nvim",
            "nvim-web-devicons"
        }
    },
    {
        "andweeb/presence.nvim",
	    config = true
    },
    {
        "lambdalisue/suda.vim",
        init = function()
            --vim.g.suda_smart_edit = 1
        end
    },
    {
        "jpalardy/vim-slime",
        init = function()
            vim.g.slime_target = "wezterm"
            vim.g.slime_default_config = {
                pane_direction = "right"
            }
        end
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                },
            },
            presets = {
                bottom_search = false, -- use a classic bottom cmdline for search
                command_palette = true, -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false, -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = false, -- add a border to hover docs and signature help
            },
            messages = {
                enabled = false, -- kinda too spammy IMO, maybe filter later
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
            "hrsh7th/nvim-cmp",
            "nvim-treesitter/nvim-treesitter",
        },
        build = ":TSInstall! vim regex lua bash markdown markdown_inline"
    }
})

-- treesitter module options
require("nvim-treesitter.install").prefer_git = true
require("nvim-treesitter.configs").setup({
    -- auto install missing parsers
    auto_install = true,
    -- syntax highlighting
    highlight = {
        enable = true
    }
})

-- apply catppuccin theme to feline
-- (require doesn't want to work in lazy spec)
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

-- LSP client
local lspconfig = require("lspconfig")
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- structure:
-- lspconfig.<server>.setup({})
-- see help lspconfig-all
-- or https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- dev-lang/rust[rust-analyzer]::gentoo
lspconfig.rust_analyzer.setup({
    capabilities = capabilities
})
-- sys-devel/clang::gentoo
lspconfig.clangd.setup({
    capabilities = capabilities
})
-- dev-util/bash-language-server::guru
lspconfig.bashls.setup({
    capabilities = capabilities
})
-- dev-util/yaml-language-server::guru
lspconfig.yamlls.setup({
    capabilities = capabilities
})
-- dev-util/lua-language-server::guru
lspconfig.lua_ls.setup({
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {
                globals = {"vim"} -- ignore for e.g. init.lua
            }
        }
    }
})
-- pyright (pipx)
lspconfig.pyright.setup({
    capabilities = capabilities
})
-- cmake-language-server (pipx)
lspconfig.cmake.setup({
    capabilities = capabilities
})
-- nginx-language-server (pipx)
lspconfig.nginx_language_server.setup({
    capabilities = capabilities
})

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

-- Completions
local cmp = require("cmp")
cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            --require('snippy').expand_snippet(args.body)
            vim.snippet.expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'snippy' },
        { name = 'path' },
    },
    {
        { name = 'buffer' },
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'git' },
    },
    {
        { name = 'buffer' },
    })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    },
    {
        { name = 'cmdline' }
    })
})

