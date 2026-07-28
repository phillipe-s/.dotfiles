return {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
        {
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            opts = {
                ensure_installed = {
                    "stylua",
                    "cspell",
                    "ruff",
                    "clang-format",
                },
            },
        },
    },
    opts = {
        ensure_installed = {
            "lua_ls",
            "clangd",
        },
        automatic_enable = {
            exclude = { "stylua" },
        },
    },
    init = function()
        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    diagnostics = { globals = { "Snacks" } },
                    runtime = { version = "LuaJIT" },
                    workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
                },
            },
        })

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                end

                map("gd", vim.lsp.buf.definition, "[g]o to [d]efinition")
                map("gD", vim.lsp.buf.declaration, "[g]o to [D]eclaration")
            end,
        })

        vim.diagnostic.config({
            signs = false,
            severity_sort = true,
            float = {
                border = "rounded",
                source = true,
                header = "",
                prefix = "",
                focusable = false,
                style = "minimal",
            },
        })
    end,
}
