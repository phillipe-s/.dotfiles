local on_normal_file_buffer = require("config.utils").on_normal_file_buffer

local autocmd = vim.api.nvim_create_autocmd
local preview_buf = nil
local preview_buf_marker = "◌"

local function add_preview_buf_marker()
    if preview_buf ~= nil and vim.api.nvim_buf_is_valid(preview_buf) then
        local preview_buf_data = require("barbar.state").get_buffer_data(preview_buf)
        preview_buf_data.name = (preview_buf_data.name or "[no name]") .. " " .. preview_buf_marker
    end
end

-- Hook to append the preview buffer marker to the file name after barbar updates tab names
local function setup_preview_buf_marker()
    local barbar_state = require("barbar.state")
    local update_names = barbar_state.update_names
    barbar_state.update_names = function(...)
        update_names(...)
        add_preview_buf_marker()
    end
end

local function setup_preview_buffers()
    local preview_buf_group = vim.api.nvim_create_augroup("PreviewBuffers", { clear = true })

    autocmd("BufAdd", {
        group = preview_buf_group,
        desc = "When a new file is being opened, set it as the preview buffer, and close the old",
        callback = on_normal_file_buffer(function(event)
            vim.schedule(function()
                if preview_buf ~= nil and preview_buf ~= event.buf then
                    pcall(vim.api.nvim_buf_delete, preview_buf, {})
                end

                preview_buf = event.buf
                require("barbar.ui.render").update(true, false)
            end)
        end),
    })

    autocmd({ "BufWritePost", "BufModifiedSet" }, {
        group = preview_buf_group,
        desc = "When a preview buffers file is modified or saved, remove it as a preview buffer, and rerender the tabs",
        callback = on_normal_file_buffer(function(event)
            if event.buf == preview_buf then
                preview_buf = nil
                require("barbar.ui.render").update(true, false)
            end
        end),
    })
end

return {
    {
        "romgrk/barbar.nvim",
        version = "^1.0.0",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "lewis6991/gitsigns.nvim", "nvim-tree/nvim-web-devicons" },
        opts = {
            animation = false,
            icons = {
                button = false,
                separator = { left = "", right = "" },
                separator_at_end = false,
                inactive = { separator = { left = "", right = "" } },
                pinned = { button = "", filename = true },
            },
        },
        keys = {
            { "<C-1>", "<Cmd>BufferGoto 1<CR>", desc = "Go to buffer 1" },
            { "<C-2>", "<Cmd>BufferGoto 2<CR>", desc = "Go to buffer 2" },
            { "<C-3>", "<Cmd>BufferGoto 3<CR>", desc = "Go to buffer 3" },
            { "<C-4>", "<Cmd>BufferGoto 4<CR>", desc = "Go to buffer 4" },
            { "<C-5>", "<Cmd>BufferGoto 5<CR>", desc = "Go to buffer 5" },
            {
                "<leader>bp",
                function()
                    vim.cmd.BufferPin()
                    if vim.api.nvim_get_current_buf() == preview_buf then
                        preview_buf = nil
                    end
                end,
                desc = "[b]uffer [p]in",
            },
            { "<leader>bd", "<Cmd>BufferClose<CR>", desc = "[b]uffer [d]elete" },
            {
                "<leader>bt",
                function()
                    vim.o.showtabline = vim.o.showtabline == 0 and 2 or 0
                end,
                desc = "[b]ufferline [t]oggle",
            },
        },
        config = function(_, opts)
            setup_preview_buf_marker()
            setup_preview_buffers()
            require("barbar").setup(opts)
        end,
    },
}
