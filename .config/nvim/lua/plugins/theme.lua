return {
    -- Main colour scheme
    {
        "catppuccin/nvim",
        name = "catppuccin",
        version = "*",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
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
            }
        },
        init = function()
            -- load the colorscheme here
            vim.cmd.colorscheme "catppuccin"
        end
    },

    -- Status line
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            { "nvim-tree/nvim-web-devicons", lazy = true }
        },
        opts = {
            options = {
                theme = "auto",
                component_separators = '',
                section_separators = { left = '', right = '' },
            }
        }
    },

    -- Noice UI framework
    {
        "folke/noice.nvim",
        version = "*",
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
        }
    },
}
