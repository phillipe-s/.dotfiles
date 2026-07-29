return {
    {
        "projekt0n/github-nvim-theme",
        name = "github-theme",
        lazy = false,
        priority = 1000,
        config = function()
            local spec = require("github-theme.spec").load("github_dark_default")
            local colors = {
                text = spec.fg1,
                text_muted = spec.fg2,
                accent = spec.palette.accent.fg,
                cursor = spec.palette.accent.fg,
                cursor_line = spec.bg2,

                bg_float = spec.bg0,
                bg_editor = spec.bg1,
                bg_transparent = "NONE",
                border = spec.palette.border.default,
                border_muted = spec.palette.border.muted,

                neutral = spec.palette.neutral.muted,
                blue = spec.palette.blue.base,
                blue_bright = spec.palette.blue.bright,
                green = spec.palette.green.base,
                green_bright = spec.palette.green.bright,
                yellow = spec.palette.yellow.base,
                yellow_bright = spec.palette.yellow.bright,
                red = spec.palette.red.base,
                red_bright = spec.palette.red.bright,
                purple = spec.palette.magenta.base,
                purple_bright = spec.palette.magenta.bright,
                pink = spec.palette.pink.base,
                pink_bright = spec.palette.pink.bright,
                cyan = spec.palette.cyan.base,
                cyan_bright = spec.palette.cyan.bright,
                orange = spec.palette.orange,

                success = spec.palette.green.base,
                attention = spec.palette.yellow.base,
                severe = spec.palette.severe.fg,
                danger = spec.palette.danger.fg,

                diff_add = spec.diff.add,
                diff_delete = spec.diff.delete,
            }

            vim.g.github_dark_default_colors = colors

            local function github_dark_default_groups()
                local function neovim_groups()
                    local spell_underline = { sp = colors.text_muted, style = "underdotted" }

                    return {
                        CursorLine = { bg = colors.cursor_line },
                        TabLineFill = { bg = colors.bg_transparent },
                        NormalFloat = { bg = colors.bg_float },
                        FloatBorder = { fg = colors.border, bg = colors.bg_float },
                        DiagnosticUnderlineInfo = spell_underline,
                        SpellBad = spell_underline,
                        SpellCap = spell_underline,
                        SpellLocal = spell_underline,
                        SpellRare = spell_underline,
                    }
                end

                local function barbar_groups()
                    local statuses = {
                        Current = { bg = colors.bg_transparent, fg = colors.text },
                        Inactive = { bg = colors.bg_float, fg = colors.text_muted },
                        Visible = { bg = colors.bg_editor, fg = colors.text_muted },
                    }

                    local groups = {
                        BufferTabpageFill = { bg = colors.bg_float },
                    }

                    for status, highlight in pairs(statuses) do
                        local prefix = "Buffer" .. status

                        groups[prefix] = highlight
                        groups[prefix .. "Mod"] = { bg = highlight.bg, fg = colors.attention }
                        groups[prefix .. "Target"] = { bg = highlight.bg, fg = colors.danger }
                    end

                    return groups
                end

                local function minifiles_groups()
                    return {
                        MiniFilesTitle = { bg = colors.bg_float, fg = colors.blue },
                        MiniFilesTitleFocused = { bg = colors.bg_float, fg = colors.blue },
                    }
                end

                local function gitsigns_groups()
                    return {
                        GitSignsTopdelete = { link = "GitSignsChange" },
                        GitSignsTopdeleteNr = { link = "GitSignsChangeNr" },
                        GitSignsTopdeleteLn = { link = "GitSignsChangeLn" },
                        GitSignsTopdeleteCul = { link = "GitSignsChangeCul" },
                        GitSignsAddPreview = { bg = colors.diff_add },
                        GitSignsDeletePreview = { bg = colors.diff_delete },
                        GitSignsDeleteVirtLn = { bg = colors.diff_delete },
                    }
                end

                local function snacks_groups()
                    local groups = {
                        SnacksNotifierHistory = { bg = colors.bg_float, fg = colors.text },
                        SnacksNotifierMinimal = { bg = colors.bg_float, fg = colors.text },
                        SnacksTitle = { bg = colors.bg_editor, fg = colors.blue },
                        SnacksPicker = { bg = colors.bg_editor },
                        SnacksPickerBorder = { bg = colors.bg_editor, fg = colors.border_muted },
                        SnacksPickerPreviewTitle = { bg = colors.bg_editor, fg = colors.blue },
                        SnacksLazygitInactiveBorder = { fg = colors.border_muted },
                        SnacksIndent = { fg = colors.border_muted },
                        SnacksIndentScope = { fg = colors.neutral },
                    }

                    local levels = {
                        Trace = colors.text_muted,
                        Debug = colors.text_muted,
                        Info = colors.accent,
                        Warn = colors.attention,
                        Error = colors.danger,
                    }

                    for level, level_fg in pairs(levels) do
                        groups["SnacksNotifier" .. level] = { bg = colors.bg_float, fg = colors.text }
                        groups["SnacksNotifierIcon" .. level] = { bg = colors.bg_float, fg = level_fg }
                        groups["SnacksNotifierBorder" .. level] = { bg = colors.bg_float, fg = level_fg }
                        groups["SnacksNotifierTitle" .. level] = { bg = colors.bg_float, fg = level_fg }
                        groups["SnacksNotifierFooter" .. level] = { bg = colors.bg_float, fg = level_fg }
                    end

                    return groups
                end

                local function noice_groups()
                    return {
                        NoiceCmdlinePopup = { bg = colors.bg_float, fg = colors.text },
                        NoiceCmdlinePopupBorder = { bg = colors.bg_float, fg = colors.blue },
                        NoiceCmdlinePopupBorderCmdline = { bg = colors.bg_float, fg = colors.border },
                        NoiceCmdlinePopupTitle = { bg = colors.bg_float, fg = colors.blue },
                        NoiceCmdlinePopupTitleCmdline = { bg = colors.bg_float, fg = colors.blue },
                    }
                end

                local function treesitter_context_groups()
                    return {
                        TreesitterContext = { fg = colors.text, bg = colors.bg_transparent },
                        TreesitterContextBottom = { sp = colors.neutral, style = "underline" },
                        TreesitterContextLineNumberBottom = { sp = colors.neutral, style = "underline" },
                    }
                end

                local function rainbow_delimiters_groups()
                    return {
                        RainbowDelimiterRed = { fg = colors.red_bright },
                        RainbowDelimiterYellow = { fg = colors.yellow_bright },
                        RainbowDelimiterBlue = { fg = colors.blue_bright },
                        RainbowDelimiterGreen = { fg = colors.green_bright },
                        RainbowDelimiterPink = { fg = colors.pink_bright },
                        RainbowDelimiterPurple = { fg = colors.purple_bright },
                    }
                end

                return vim.tbl_extend(
                    "force",
                    neovim_groups(),
                    barbar_groups(),
                    minifiles_groups(),
                    gitsigns_groups(),
                    snacks_groups(),
                    noice_groups(),
                    treesitter_context_groups(),
                    rainbow_delimiters_groups()
                )
            end

            require("github-theme").setup({
                options = { transparent = true },
                groups = { github_dark_default = github_dark_default_groups() },
            })
            vim.cmd.colorscheme("github_dark_default")
        end,
    },
}
