return {
    { "nvim-tree/nvim-web-devicons", opts = {} },
    { "folke/which-key.nvim", event = "VeryLazy", opts = {} },
    {
        "folke/todo-comments.nvim",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false },
    },
    {
        "mbbill/undotree",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end,
    },
    {
        "folke/noice.nvim",
        event = "VimEnter",
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = { lsp = { progress = { enabled = false } }, presets = { lsp_doc_border = true } },
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown" },
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        opts = { sign = { enabled = false } },
    },
    {
        "christoomey/vim-tmux-navigator",
        keys = {
            { "<C-h>", "<cmd><C-U>TmuxNavigateLeft<CR>", desc = "Move to left split or pane" },
            { "<C-j>", "<cmd><C-U>TmuxNavigateDown<CR>", desc = "Move to lower split or pane" },
            { "<C-k>", "<cmd><C-U>TmuxNavigateUp<CR>", desc = "Move to upper split or pane" },
            { "<C-l>", "<cmd><C-U>TmuxNavigateRight<CR>", desc = "Move to right split or pane" },
        },
    },
    {
        "HiPhish/rainbow-delimiters.nvim",
        event = { "BufReadPost", "BufNewFile" },
        init = function()
            vim.g.rainbow_delimiters = {
                -- sets the order of the highlighted brackets
                highlight = {
                    "RainbowDelimiterBlue",
                    "RainbowDelimiterGreen",
                    "RainbowDelimiterYellow",
                    "RainbowDelimiterRed",
                    "RainbowDelimiterPink",
                    "RainbowDelimiterPurple",
                },
            }
        end,

        -- Makes rainbow-delimiters create named highlight namespaces instead of anonymous ones.
        -- This allows nvim-ufo and nvim-treesitter-context to discover and copy delimiter
        -- highlights into folded and context lines.
        config = function()
            getmetatable(require("rainbow-delimiters.lib").nsids).__index = function(namespaces, lang)
                local id = vim.api.nvim_create_namespace("nvim.rainbow-delimiters." .. lang)
                rawset(namespaces, lang, id)
                return id
            end
        end,
    },
}
