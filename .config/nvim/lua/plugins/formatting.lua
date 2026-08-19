return {
    "stevearc/conform.nvim",
    lazy = true,
    opts = {
        default_format_opts = { lsp_format = "fallback" },
        -- format_on_save = { timeout_ms = 1000 },
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "ruff_format" },
            c = { "clang-format" },
        },
        formatters = {
            stylua = {
                prepend_args = { "--indent-type", "Spaces" },
            },
        },
    },
    keys = {
        {
            "<leader>f",
            function() require("conform").format({ async = true }) end,
            mode = { "n", "v" },
            desc = "[f]ormat",
        },
    },
    init = function()
        -- use conform for formatting instead of vim's built-in formatter
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        vim.keymap.set("n", "<leader>F", "mzgg=G`z", { desc = "[F]ormat with Vim (keep cursor position)" })
    end,
}
