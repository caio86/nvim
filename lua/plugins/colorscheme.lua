return {
  {
    "folke/tokyonight.nvim",
    lazy = false,    -- load at startup
    priority = 1000, -- before other plugins, so highlights are ready
    opts = { style = "night" },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },
}
