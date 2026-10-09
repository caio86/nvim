local is_nixos = vim.uv.fs_stat("/etc/NIXOS") ~= nil

return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    cond = not is_nixos,
    lazy = false,
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      -- Mason package names (not LSP names)
      ensure_installed = { "clang-format", "stylua", "shfmt", "tflint", "goimports" },
    },
  },
}
