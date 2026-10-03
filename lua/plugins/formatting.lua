return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true })
      end,
      mode = { "n", "v" },
      desc = "Format buffer / selection",
    },
  },
  opts = {
    formatters_by_ft = {
      python = { "ruff_organize_imports", "ruff_format" },
      c = { "clang-format" },
      cpp = { "clang-format" },
      lua = { "stylua" },
      terraform = { "terraform_fmt" },
      nix = { "nixfmt" },
    },

    -- If no formatter is configured for a filetype, use the LSP's formatter
    default_format_opts = { lsp_format = "fallback" },

    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 1000 }
    end,
  },
  config = function(_, opts)
    require("conform").setup(opts)

    -- :FormatDisable (everywhere), :FormatDisable! (this buffer only), :FormatEnable
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, { bang = true, desc = "Disable format-on-save" })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, { desc = "Enable format-on-save" })
  end,
}
