return {
    -- Treesitter for almost any syntax
    {
        "nvim-treesitter/nvim-treesitter",
        version = "*",
        build = ":TSUpdate"
    },
    
    -- Syntax for Gentoo things like ebuilds
    {
        "gentoo/gentoo-syntax",
        version = "*",
        dependencies = {
            { "dense-analysis/ale" }
        }
    },

    -- Indent marker lines
    {
        "lukas-reineke/indent-blankline.nvim",
        version = "*",
        main = "ibl",
        opts = {}
    },

}
