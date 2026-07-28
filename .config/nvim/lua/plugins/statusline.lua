local function lualine_theme()
    local theme = vim.deepcopy(require("lualine.themes.github_dark_default"))
    local spec = require("github-theme.spec").load("github_dark_default")

    for _, mode in ipairs({ "normal", "insert", "visual", "replace", "command", "terminal", "inactive" }) do
        theme[mode].b.bg = spec.bg0
        theme[mode].b.fg = spec.palette.scale.gray[2]
        theme[mode].c.bg = spec.bg0
        theme[mode].c.fg = spec.palette.scale.gray[2]
    end

    return theme
end

local function wide_statusline()
    return vim.go.columns >= 95
end

local function format_mode(mode)
    if wide_statusline() then
        return mode
    end

    return mode:sub(1, 1)
end

local function formatter()
    local formatters, uses_lsp = require("conform").list_formatters_to_run(0)
    local names = vim.tbl_map(function(item)
        return item.name
    end, formatters)

    if uses_lsp then
        table.insert(names, "LSP")
    end

    if vim.tbl_isempty(names) then
        return ""
    end

    return "󰉼 " .. table.concat(names, ", ")
end

local function linters()
    local lint = require("lint")
    local names = lint.linters_by_ft[vim.bo.filetype] or {}

    if vim.tbl_isempty(names) then
        return ""
    end

    return "󰃢 " .. table.concat(names, ", ")
end

local function copilot_status()
    local ok, status = pcall(require, "copilot.status")
    if ok and status.data.status == "InProgress" then
        return ""
    end

    return ""
end

local function copilot_color()
    local ok, client = pcall(require, "copilot.client")
    if ok and client.is_disabled() then
        local spec = require("github-theme.spec").load("github_dark_default")
        return { fg = spec.palette.fg.subtle }
    end

    return {}
end

return {
    -- { "nvim-mini/mini.statusline", version = false, opts = {} },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = function()
            return {
                options = {
                    globalstatus = true,
                    section_separators = { left = "", right = "" },
                    component_separators = { left = "", right = "" },
                    theme = lualine_theme(),
                },
                sections = {
                    lualine_a = { { "mode", fmt = format_mode } },
                    lualine_b = {
                        { "branch", icon = "" },
                        { "diff", symbols = { added = " ", modified = " ", removed = " " } },
                    },
                    lualine_c = {
                        {
                            "filename",
                            path = 1,
                            file_status = false,
                            cond = wide_statusline,
                        },
                        {
                            "filename",
                            path = 0,
                            file_status = false,
                            cond = function()
                                return not wide_statusline()
                            end,
                        },
                    },
                    lualine_x = {
                        { linters, cond = wide_statusline },
                        { formatter, cond = wide_statusline },
                    },
                    lualine_y = {
                        {
                            "lsp_status",
                            symbols = { done = "" },
                            ignore_lsp = { "copilot" },
                            cond = wide_statusline,
                        },
                        "diagnostics",
                        "filetype",
                        {
                            copilot_status,
                            color = copilot_color,
                            padding = { left = 1, right = 2 },
                        },
                    },
                    lualine_z = { "location" },
                },
            }
        end,
    },
}
