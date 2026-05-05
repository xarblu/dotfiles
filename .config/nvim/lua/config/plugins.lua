-- list of plugins matching <name>.lua in plugins/
-- loaded in this order, unless a plugin is already loaded
-- as a dependecy of another
local plugins = {
    "catppuccin",
    "noice",
    "lualine",
    "presence",
    "suda",
    "gitsigns",
    "gentoo-syntax",
    "indent-blankline",
    "nvim-lspconfig",
    "blink-cmp",
    "tree-sitter-manager",
}

local loaded = {}

local load_plugin
local load_plugins

-- load a plugin and its dependencies recursively
load_plugin = function(name)
    -- don't load multiple times
    for _, l in ipairs(loaded) do
        if name == l then
            return
        end
    end
    table.insert(loaded, name)

    local p = require("plugins." .. name)

    -- optional dependencies
    -- installed/loaded before
    if p.dependencies ~= nil then
        load_plugins(p.dependencies)
    end

    -- required spec table
    vim.pack.add({p.spec})

    -- optional config function
    if p.config ~= nil then
        p.config()
    end
end

-- load all given plugins
load_plugins = function(names)
    for _, name in ipairs(names) do
        load_plugin(name)
    end
end

load_plugins(plugins)
