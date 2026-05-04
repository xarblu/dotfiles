return {
    spec = {
        src = "https://github.com/lambdalisue/suda.vim"
    },
    config = function()
        vim.g.suda = { executable = "sudo" }
        --vim.g.suda_smart_edit = 1
    end
}
