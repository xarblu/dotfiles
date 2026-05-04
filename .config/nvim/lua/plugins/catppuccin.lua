return {
    spec = {
        src = "https://github.com/catppuccin/nvim",
        name = "catppuccin"
    },
    config = function()
        require("catppuccin").setup({
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
        })

        vim.cmd.colorscheme "catppuccin"
    end
}
