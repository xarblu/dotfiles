-- LSP diagnostics
vim.keymap.set("n", "gl", vim.diagnostic.open_float)
vim.o.autocomplete = true
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
        if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, ev.buf, {autotrigger = true})
        end
    end
})
vim.opt.complete:append("o")
vim.opt.completeopt = {"fuzzy", "menuone", "noinsert"}
vim.o.pumheight = 5
vim.o.pumborder = "rounded"
