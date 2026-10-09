local is_nixos = vim.uv.fs_stat("/etc/NIXOS") ~= nil

-- lsp-server: executable
local servers = {
  lua_ls = "lua-language-server",
  basedpyright = "basedpyright-langserver",
  ruff = "ruff",
  clangd = "clangd",
  yamlls = "yaml-language-server",
  terraformls = "terraform-ls",
  nil_ls = "nil",
  gopls = "gopls",
  vtsls = "vtsls",
  html = "vscode-html-language-server",
  cssls = "vscode-css-language-server",
  eslint = "vscode-eslint-language-server",
  jsonls = "vscode-json-language-server",
}

local not_in_mason = { nil_ls = true }

return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } },
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "saghen/blink.cmp",
      { "mason-org/mason.nvim", cond = not is_nixos, opts = {} },
      {
        "mason-org/mason-lspconfig.nvim",
        cond = not is_nixos,
        opts = {
          ensure_installed = vim.tbl_filter(function(s)
            return not not_in_mason[s]
          end, vim.tbl_keys(servers)),
          automatic_enable = false,
        },
      },
    },
    config = function()
      -- Diagnostics display
      vim.diagnostic.config({
        severity_sort = true,
        update_in_insert = false,
        virtual_text = { spacing = 2 },
        float = { border = "rounded", source = true },
      })

      vim.lsp.config("vtsls", {
        settings = { vtsls = { autoUseWorkspaceTsdk = true } },
      })

      -- blink.cmp
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      -- Per server settings
      vim.lsp.config("basedpyright", {
        settings = {
          basedpyright = {
            analysis = { typeCheckingMode = "standard" },
          },
        },
      })

      vim.lsp.config("ruff", {
        capabilities = {
          general = { positionEncodings = { "utf-16" } },
        },
      })

      vim.lsp.config("nil_ls", {
        settings = { ["nil"] = { formatting = { command = { "nixfmt" } } } },
      })

      vim.lsp.config("clangd", {
        cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed" },
      })

      vim.lsp.config("yamlls", {
        settings = { yaml = { keyOrdering = false } },
      })

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            analyses = { unusedparams = true },
            staticcheck = true,
            usePlaceholders = true,
          },
        },
      })

      -- Buffer-local setup when a server attaches
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)

          -- basedpyright handles hover; avoid duplicate popups from ruff
          if client and client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
          end

          local function bmap(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = "LSP: " .. desc })
          end

          bmap("gd", vim.lsp.buf.definition, "Go to definition")
          bmap("gD", vim.lsp.buf.declaration, "Go to declaration")
          bmap("<leader>d", vim.diagnostic.open_float, "Line diagnostics")
          bmap("<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", "Document symbols")
          bmap(
            "<leader>fS",
            "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
            "Workspace symbols"
          )
          bmap("<leader>co", function()
            vim.lsp.buf.code_action({
              context = { only = { "source.organizeImports" }, diagnostics = {} },
              apply = true,
            })
          end, "Organize imports")

          if client and client:supports_method("textDocument/inlayHint") then
            bmap("<leader>ch", function()
              local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf })
              vim.lsp.inlay_hint.enable(not enabled, { bufnr = ev.buf })
            end, "Toggle inlay hints")
          end
        end,
      })

      -- Enable only manually defined lsp servers that have exe installed
      for server, exe in pairs(servers) do
        if vim.fn.executable(exe) == 1 then
          vim.lsp.enable(server)
        end
      end
    end,
  },
}
