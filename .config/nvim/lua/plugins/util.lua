return {
    -- Write files with sudo from user session
    {
        "lambdalisue/suda.vim",
        version = "*",
        init = function()
            vim.g.suda = { executable = "sudo" }
            --vim.g.suda_smart_edit = 1
        end
    },

    -- Git Status
    {
        "lewis6991/gitsigns.nvim",
        version = "*",
        opts = {}
    },
}
