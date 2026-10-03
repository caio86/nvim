return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- filetype -> { linter name = executable }
    local wanted = {
      terraform = { tflint = "tflint" },
      nix = { statix = "statix" },
    }

    -- Only enable linters whose executable exists on this machine
    for ft, linters in pairs(wanted) do
      local available = {}
      for name, exe in pairs(linters) do
        if vim.fn.executable(exe) == 1 then
          table.insert(available, name)
        end
      end
      if #available > 0 then
        lint.linters_by_ft[ft] = available
      end
    end

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("UserLint", { clear = true }),
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
