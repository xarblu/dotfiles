return {
    -- Treesitter for almost any syntax
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        branch = 'main',
        build = ':TSUpdate'
    },
    
    -- Syntax for Gentoo things like ebuilds
    {
        'gentoo/gentoo-syntax',
        version = '*'
    },

    -- Indent marker lines
    {
        'lukas-reineke/indent-blankline.nvim',
        version = '*',
        main = 'ibl',
        opts = {}
    },

}
