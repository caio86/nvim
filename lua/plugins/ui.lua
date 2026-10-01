return {
  -- File icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto", -- follows the active colorscheme
        globalstatus = true,
        component_separators = "|",
        section_separators = "",
      },
    },
  },
}
