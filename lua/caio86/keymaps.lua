local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
end

-- Clear search highlight
map({"i", "n"}, "<Esc>", "<cmd>nohlsearch<cr><esc>", "Clear search highlight")

-- Window navigation
map("n", "<C-h>", "<C-w>h", "Go to left window")
map("n", "<C-j>", "<C-w>j", "Go to lower window")
map("n", "<C-k>", "<C-w>k", "Go to upper window")
map("n", "<C-l>", "<C-w>l", "Go to right window")

-- Buffer navigation
map("n", "<S-h>", "<cmd>bprevious<cr>", "Previous buffer")
map("n", "<S-l>", "<cmd>bnext<cr>", "Next buffer")
map("n", "<leader>bb", "<cmd>e #<cr>", "Switch to Other Buffer")
map("n", "<leader>bd", "<cmd>bd<cr>", "Buffer Delete")

-- windows
map("n", "<leader>ww", "<C-W>p", "Other window")
map("n", "<leader>wd", "<C-W>c", "Delete window")
map("n", "<leader>w-", "<C-W>s", "Split window below")
map("n", "<leader>w|", "<C-W>v", "Split window right")
map("n", "<leader>-", "<C-W>s", "Split window below")
map("n", "<leader>|", "<C-W>v", "Split window right")

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", "Last Tab")
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", "First Tab")
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", "New Tab")
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", "Next Tab")
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", "Close Tab")
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", "Previous Tab")

-- Keep cursor centered when scrolling / searching
map("n", "<C-d>", "<C-d>zz", "Scroll down (centered)")
map("n", "<C-u>", "<C-u>zz", "Scroll up (centered)")
map("n", "n", "nzzzv", "Next search result (centered)")
map("n", "N", "Nzzzv", "Previous search result (centered)")

-- Move selected lines up/down
map("n", "<A-j>", "<cmd>m .+1<cr>==", "Move down")
map("n", "<A-k>", "<cmd>m .-2<cr>==", "Move up")
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", "Move down")
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", "Move up")
map("v", "J", ":m '>+1<cr>gv=gv", "Move selection down")
map("v", "K", ":m '<-2<cr>gv=gv", "Move selection up")

-- Keep selection after indenting
map("v", "<", "<gv", "Indent left (keep selection)")
map("v", ">", ">gv", "Indent right (keep selection)")

-- Paste over selection without overwriting the register
map("x", "<leader>p", [["_dP]], "Paste without yanking selection")

-- Leave terminal mode easily
map("t", "<Esc><Esc>", [[<C-\><C-n>]], "Exit terminal mode")

-- Lazy plugin manager
map("n", "<leader>L", "<cmd>Lazy<cr>", "Open Lazy plugin manager")

