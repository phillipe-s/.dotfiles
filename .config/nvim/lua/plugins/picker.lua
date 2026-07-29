local set = vim.keymap.set
local backdrop_blend = 50

local function in_git_worktree()
    vim.fn.system({ "git", "rev-parse", "--is-inside-work-tree" })
    return vim.v.shell_error == 0
end

local picker_backdrop = {
    transparent = false,
    win = {
        on_win = function(win)
            vim.wo[win.win].winhighlight = "Normal:SnacksBackdrop"
            vim.wo[win.win].winblend = backdrop_blend
        end,
    },
}

return {
    "folke/snacks.nvim",
    opts = {
        picker = {
            enabled = true,
            formatters = { file = { filename_first = true } },
            layout = {
                preset = function()
                    return vim.o.columns >= 120 and "wide_preview" or "vertical_preview"
                end,
            },
            layouts = {
                wide_preview = {
                    layout = {
                        backdrop = picker_backdrop,
                        box = "horizontal",
                        width = 0.8,
                        min_width = 120,
                        height = 0.8,
                        {
                            box = "vertical",
                            border = true,
                            title = "{title} {live} {flags}",
                            { win = "input", height = 1, border = "bottom" },
                            { win = "list", border = "none" },
                        },
                        { win = "preview", title = "{preview}", border = true, width = 0.7 },
                    },
                },
                vertical_preview = {
                    layout = {
                        backdrop = picker_backdrop,
                        width = 0.5,
                        min_width = 80,
                        height = 0.85,
                        min_height = 30,
                        box = "vertical",
                        border = true,
                        title = "{title} {live} {flags}",
                        title_pos = "center",
                        { win = "input", height = 1, border = "bottom" },
                        { win = "list", border = "none" },
                        { win = "preview", title = "{preview}", height = 0.7, border = "top" },
                    },
                },
            },
        },
    },
    init = function()
        local function set_default_project_picker_keymaps()
            set("n", "<C-p>", function() Snacks.picker.smart() end, { desc = "pick [p]roject files" })
            set("n", "<leader>pw", function() Snacks.picker.grep() end, { desc = "[p]ick [w]ords" })
            set("n", "<leader>pW", function() Snacks.picker.grep_word() end, { desc = "[p]ick [W]ord" })
        end

        set("n", "<leader>pf", function() Snacks.picker.files() end, { desc = "[p]ick [f]iles (all)" })
        set("n", "<C-S-p>", function() Snacks.picker.resume() end, { desc = "[P]icker resume" })
        set("n", "<leader>ps", function() Snacks.picker.lsp_symbols() end, { desc = "[p]ick [s]ymbols (document)" })
        set("n", "<leader>pS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "[p]ick [S]ymbols (workspace)" })
        set("n", "<leader>pb", function() Snacks.picker.buffers() end, { desc = "[p]ick [b]uffers" })
        set("n", "<leader>pd", function() Snacks.picker.diagnostics() end, { desc = "[p]ick [d]iagnostics (project)" })
        set("n", "<leader>ph", function() Snacks.picker.help() end, { desc = "[p]ick [h]elp" })
        set("n", "<leader>pp", function() Snacks.picker() end, { desc = "[p]ick [p]icker" })

        local function set_git_project_picker_keymaps()
            set("n", "<C-p>", function()
                Snacks.picker.smart({
                    multi = {
                        "buffers",
                        { source = "git_files", untracked = true },
                    },
                })
            end, { desc = "pick [p]roject files" })

            set("n", "<leader>pw", function() Snacks.picker.git_grep({ untracked = true }) end, { desc = "[p]ick [w]ords" })

            set("n", "<leader>pW", function()
                Snacks.picker.git_grep({
                    untracked = true,
                    cmd_args = { "--fixed-strings", "--word-regexp" },
                    search = function(picker)
                        return picker:word()
                    end,
                    live = false,
                })
            end, { desc = "[p]ick [W]ord" })
        end

        vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
            group = vim.api.nvim_create_augroup("ProjectPickerKeymaps", { clear = true }),
            desc = "Setup picker keymaps based on git worktree presence",
            callback = function()
                if in_git_worktree() then
                    set_git_project_picker_keymaps()
                else
                    set_default_project_picker_keymaps()
                end
            end,
        })
    end,
}
