local set = vim.keymap.set

-- === LEADER KEY ===  --
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- === UTIL === --
set("i", "jk", "<ESC>", { desc = "Exit insert mode" })
set("n", "<leader>w", "<cmd>w<CR>", { desc = "[w]rite file" })
set("n", "<leader>q", "<cmd>q<CR>", { desc = "[q]uit" })

-- === KEEP CURSOR CENTERED === --
set("n", "J", "mzJ`z", { desc = "[J]oin lines (keep cursor position)" })
set("n", "<C-d>", "<C-d>zz", { desc = "Scroll [d]own (centered)" })
set("n", "<C-u>", "<C-u>zz", { desc = "Scroll [u]p (centered)" })
set("n", "n", "nzzzv", { desc = "[n]ext search result (centered)" })
set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- === MOVE LINES === --
set("x", "J", "<Esc><cmd>silent! '<,'>m '>+1 | silent! normal! gv=gv<CR>", { desc = "Move selected lines down" })
set("x", "K", "<Esc><cmd>silent! '<,'>m '<-2 | silent! normal! gv=gv<CR>", { desc = "Move selected lines up" })
set("x", "<S-Tab>", "<gv", { desc = "Outdent selected lines" })
set("x", "<Tab>", ">gv", { desc = "Indent selected lines" })

-- === SEARCH === --
set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "[c]lear search highlights" })

-- === COPY & PASTE === --
set("x", "<leader>p", '"_dP', { desc = "[p]aste without yanking" })
set({ "n", "v" }, "<leader>d", '"_d', { desc = "[d]elete without yanking" })
set("n", "x", '"_x', { desc = "delete char without yanking"})

-- === SPLITS === --
set("n", "<leader>s", "<cmd>vsplit<CR>", { desc = "Split window vertically" })
set("n", "<leader>S", "<cmd>split<CR>", { desc = "Split window horizontally" })
