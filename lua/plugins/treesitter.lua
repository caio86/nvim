return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")

    local parsers = {
      "python", "c", "cpp", "yaml", "hcl", "terraform",

      "go", "gomod", "java", "html", "css", "javascript", "typescript", "tsx",

      "json", "toml", "bash", "nix", "make", "cmake", "dockerfile",
      "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
      "diff", "gitcommit", "git_config", "regex",
    }

    if vim.fn.executable("tree-sitter") == 1 then
      ts.install(parsers)
    else
      vim.notify(
        "tree-sitter CLI not found: parsers can't be installed on this machine",
        vim.log.levels.WARN
      )
    end


    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
      callback = function(ev)
        local lang = vim.treesitter.language.get_lang(ev.match)
        if lang then
          pcall(vim.treesitter.start, ev.buf, lang)
        end
      end,
    })

  end
}
