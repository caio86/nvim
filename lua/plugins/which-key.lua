return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- Names for the leader groups
    spec = {
      { "<leader>c", group = "code" },
      { "<leader>f", group = "find" },
      { "<leader>g", group = "git" },
      { "<leader>h", group = "hunks", mode = { "n", "v" } },
      { "<leader>t", group = "toggle" },
      { "<leader>w", group = "window" },
      { "<leader>w", group = "buffer" },
      { "<leader><tab>", group = "tabs" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer-local keymaps",
    },
  },
}
