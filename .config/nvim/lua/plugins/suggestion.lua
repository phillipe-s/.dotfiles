return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
        suggestion = {
            enabled = true,
            auto_trigger = true,
            trigger_on_accept = false,
            keymap = {
                accept = "<Tab>",
                dismiss = "<C-]>",
            },
        },
        panel = { enabled = false },
    },
    config = function(_, opts)
        require("copilot").setup(opts)
        require("copilot.command").disable()
        require("copilot.status").register_status_notification_handler(function()
            vim.schedule(function()
                if package.loaded.lualine then
                    require("lualine").refresh({ place = { "statusline" } })
                end
            end)
        end)
    end,
}
