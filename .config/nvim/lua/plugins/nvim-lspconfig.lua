return {
    spec = {
        src = "https://github.com/neovim/nvim-lspconfig",
    },
    config = function()
        -- available configs: https://github.com/neovim/nvim-lspconfig/tree/master/lsp
        -- vim.lsp.config("<ls>, {<config>}") -- for extra config
        -- vim.lsp.enable("<ls>") -- to enable

        vim.lsp.enable("ansiblels")
        -- dev-util/bash-language-server
        vim.lsp.config("bashls", {
            -- we also want to match ebuild files
            filetypes = { "bash", "sh", "ebuild" }
        })
        vim.lsp.enable("bashls")
        vim.lsp.enable("clangd") -- llvm-core/clang
        vim.lsp.enable("cmake")
        -- dev-util/lua-language-server
        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    diagnostics = {
                        -- don't warn about "undefined global 'vim'"
                        globals = {"vim"},
                    }
                }
            }
        })
        vim.lsp.enable("lua_ls")
        vim.lsp.enable("pylsp") -- dev-python/python-lsp-server (+ dev-python/python-lsp-mypy)
        vim.lsp.enable("rust_analyzer") -- dev-lang/rust[rust-analyzer]
        vim.lsp.enable("yamlls") -- dev-util/yaml-language-server

        -- how diagnostics should be shown by default
        -- https://neovim.io/doc/user/diagnostic.html#vim.diagnostic.Opts
        vim.diagnostic.config({
            -- underline errors
            underline = true,
            -- show errors at EOL
            virtual_text = false,
            -- show errors on "virtual lines"
            virtual_lines = true,
            -- show diagnostic signs
            signs = true,
            -- whether to update in insert mode
            -- (if false only on insert->normal transition)
            update_in_insert = true,
            -- sort errors before warnings
            severity_sort = true,
        })
        -- some styling
        -- guisp requires usstyle in TMUX terminal-features
        vim.cmd("highlight DiagnosticUnderlineError gui=undercurl guisp=LightRed")
        vim.cmd("highlight DiagnosticUnderlineWarn gui=undercurl guisp=LightYellow")
        vim.cmd("highlight DiagnosticUnderlineInfo gui=undercurl guisp=LightCyan")
        vim.cmd("highlight DiagnosticUnderlineHint gui=undercurl guisp=LightGray")
    end
}
