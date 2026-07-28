return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require("lint")

        lint.linters_by_ft = {
        }

        vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
            group = vim.api.nvim_create_augroup("Lint", { clear = true }),
            callback = require("config.utils").on_normal_file_buffer(function(event)
                vim.api.nvim_buf_call(event.buf, function()
                    lint.try_lint("cspell")
                    lint.try_lint()
                end)
            end),
        })
    end,
}
