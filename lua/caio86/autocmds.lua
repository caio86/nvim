local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })
local autocmd = vim.api.nvim_create_autocmd

-- Highlight yanked text briefly
autocmd("TextYankPost", {
  group = augroup,
  callback = function() vim.hl.on_yank() end,
})

-- Remove spaces after last word on each line
autocmd({ "BufWritePre" }, {
  group = augroup,
  command = [[%s/\s\+$//e]],
})

-- Restore cursor position when reopening a file
autocmd("BufReadPost", {
  group = augroup,
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    local lines = vim.api.nvim_buf_line_count(ev.buf)
    if mark[1] > 0 and mark[1] <= lines then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Reload files changed outside Neovim
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup,
  command = "checktime",
})

-- Rebalance splits when the terminal is resized
autocmd("VimResized", {
  group = augroup,
  command = "wincmd =",
})

-- Per-filetype indentation
autocmd("FileType", {
  group = augroup,
  pattern = {
    "yaml", "json", "jsonc", "lua", "html", "css", "scss",
    "javascript", "javascriptreact", "typescript", "typescriptreact",
    "terraform", "hcl",
  },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})

autocmd("FileType", {
  group = augroup,
  pattern = { "go", "make" },
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
})
