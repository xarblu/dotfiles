return {
    -- LSP Servers and Diagnostics
    {
        'neovim/nvim-lspconfig',
        version = '*',
        config = function()
            -- available configs: https://github.com/neovim/nvim-lspconfig/tree/master/lsp
            -- vim.lsp.config('<ls>, {<config>}') -- for extra config
            -- vim.lsp.enable('<ls>') -- to enable

            vim.lsp.enable('ansiblels')
            vim.lsp.config('bashls', {
                -- we also want to match ebuild files
                filetypes = { 'bash', 'sh', 'ebuild' }
            })
            vim.lsp.enable('bashls') -- dev-util/bash-language-server
            vim.lsp.enable('clangd') -- llvm-core/clang
            vim.lsp.enable('cmake')
            vim.lsp.enable('lua_ls') -- dev-util/lua-language-server
            vim.lsp.enable('pylsp') -- dev-python/python-lsp-server (+ dev-python/python-lsp-mypy)
            vim.lsp.enable('rust_analyzer') -- dev-lang/rust[rust-analyzer]
            vim.lsp.enable('yamlls') -- dev-util/yaml-language-server

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
            vim.cmd('highlight DiagnosticUnderlineError gui=undercurl guisp=LightRed')
            vim.cmd('highlight DiagnosticUnderlineWarn gui=undercurl guisp=LightYellow')
            vim.cmd('highlight DiagnosticUnderlineInfo gui=undercurl guisp=LightCyan')
            vim.cmd('highlight DiagnosticUnderlineHint gui=undercurl guisp=LightGray')
        end
    },

    -- Completions
    {
        'saghen/blink.cmp',
        -- optional: provides snippets for the snippet source
        dependencies = { 'rafamadriz/friendly-snippets' },

        -- use a release tag to download pre-built binaries
        version = '*',
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
            -- 'super-tab' for mappings similar to vscode (tab to accept)
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = { preset = 'enter' },

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'mono'
            },

            -- (Default) Only show the documentation popup when manually triggered
            completion = { documentation = { auto_show = false } },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },

            -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
            -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
            -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
            fuzzy = { implementation = "prefer_rust_with_warning" }
        },
            opts_extend = { "sources.default" }
        }
}
