local function select(query)
  return function()
    require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
  end
end

return {
  -- Surround: ys{motion}{char}, ds{char}, cs{old}{new}, visual S{char}
  {
    "kylechui/nvim-surround",
    version = "^3.0.0",
    event = "VeryLazy",
    opts = {},
  },

  -- Auto-close brackets and quotes
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- Text objects based on the syntax tree (functions, classes, arguments...)
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      select = { lookahead = true },
    },
    keys = {
      { "af", select("@function.outer"), mode = { "x", "o" }, desc = "Around function" },
      { "if", select("@function.inner"), mode = { "x", "o" }, desc = "Inside function" },
      { "ac", select("@class.outer"), mode = { "x", "o" }, desc = "Around class" },
      { "ic", select("@class.inner"), mode = { "x", "o" }, desc = "Inside class" },
      { "aa", select("@parameter.outer"), mode = { "x", "o" }, desc = "Around parameter" },
      { "ia", select("@parameter.inner"), mode = { "x", "o" }, desc = "Inside parameter" },
      { "ai", select("@conditional.outer"), mode = { "x", "o" }, desc = "Around conditional" },
      { "ii", select("@conditional.inner"), mode = { "x", "o" }, desc = "Inside conditional" },
      { "al", select("@loop.outer"), mode = { "x", "o" }, desc = "Around loop" },
      { "il", select("@loop.inner"), mode = { "x", "o" }, desc = "Inside loop" },
    },
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash jump",
      },
      {
        "S",
        mode = { "n", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash treesitter",
      },
      {
        "r",
        mode = { "o" },
        function()
          require("flash").remote()
        end,
        desc = "Remote flash",
      },
      {
        "R",
        mode = { "o" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter search",
      },
    },
  },
}
