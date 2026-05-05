return {
    spec = {
        src = "https://github.com/romus204/tree-sitter-manager.nvim"
    },
    config = function()
        require("tree-sitter-manager").setup({
            ensure_installed = {
                -- required for noice.nvim
                "vim",
                "regex",
                "lua",
                "bash",
                "markdown",
                "markdown_inline",
            },
            auto_install = true,
            highlight = true,
        })
    end
}
