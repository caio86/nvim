-- Run with :checkhealth caio86
local M = {}

local is_nixos = vim.uv.fs_stat("/etc/NIXOS") ~= nil

-- Item: { executable, purpose, nixpkgs name, hint for other systems }
-- nix_only = true means the tool only comes from Nix (not Mason/apt).
local groups = {
  {
    title = "Base tools (required)",
    level = "error",
    items = {
      { "git", "plugin installs, git integration", "git", "apt install git" },
      { "rg", "Telescope grep and file finding", "ripgrep", "apt install ripgrep" },
      {
        "tree-sitter",
        "installing Treesitter parsers",
        "tree-sitter",
        "release binary in ~/.local/bin",
      },
      { "gcc", "compiling parsers", "gcc", "apt install build-essential" },
      { "make", "building telescope-fzf-native", "gnumake", "apt install build-essential" },
      { "curl", "downloads (Mason, blink.cmp)", "curl", "apt install curl" },
      { "unzip", "Mason package installs", "unzip", "apt install unzip" },
    },
  },
  {
    title = "Runtimes",
    level = "warn",
    items = {
      { "node", "JS-based language servers, web projects", "nodejs", "apt install nodejs npm" },
      { "npm", "Mason's JS-based servers", "nodejs", "apt install nodejs npm" },
      {
        "python3",
        "Python tooling, jdtls launcher",
        "python3",
        "apt install python3 python3-venv",
      },
      { "go", "gopls, Go projects", "go", "apt install golang-go" },
      { "java", "jdtls, Java projects", "jdk21", "apt install openjdk-21-jdk" },
    },
  },
  {
    title = "Language servers",
    level = "warn",
    items = {
      { "lua-language-server", "Lua", "lua-language-server", "Mason" },
      { "basedpyright-langserver", "Python types", "basedpyright", "Mason" },
      { "ruff", "Python lint and format", "ruff", "Mason" },
      { "clangd", "C/C++", "clang-tools", "Mason" },
      { "yaml-language-server", "YAML", "yaml-language-server", "Mason" },
      { "terraform-ls", "Terraform", "terraform-ls", "Mason" },
      { "nil", "Nix", "nil", "install via Nix", nix_only = true },
      { "gopls", "Go", "gopls", "Mason" },
      { "vtsls", "JS/TS/React", "vtsls", "Mason" },
      { "vscode-html-language-server", "HTML", "vscode-langservers-extracted", "Mason" },
      { "vscode-css-language-server", "CSS", "vscode-langservers-extracted", "Mason" },
      { "vscode-json-language-server", "JSON", "vscode-langservers-extracted", "Mason" },
      { "vscode-eslint-language-server", "ESLint", "vscode-langservers-extracted", "Mason" },
      { "jdtls", "Java", "jdt-language-server", "Mason" },
    },
  },
  {
    title = "Formatters and linters",
    level = "warn",
    items = {
      { "stylua", "Lua formatting", "stylua", "Mason" },
      { "clang-format", "C/C++ formatting", "clang-tools", "Mason" },
      { "nixfmt", "Nix formatting", "nixfmt", "install via Nix", nix_only = true },
      { "statix", "Nix linting", "statix", "install via Nix", nix_only = true },
      { "goimports", "Go formatting", "gotools", "Mason" },
      { "prettier", "JS/TS/CSS/HTML/JSON formatting", "prettier", "Mason" },
      { "google-java-format", "Java formatting", "google-java-format", "Mason" },
      { "tflint", "Terraform linting", "tflint", "Mason" },
      {
        "terraform",
        "Terraform formatting",
        "terraform",
        "install separately (HashiCorp repo or OpenTofu)",
      },
    },
  },
}

local function java_major()
  if vim.fn.executable("java") == 0 then
    return nil
  end
  local out = vim.fn.system({ "java", "-version" })
  return tonumber(out:match('version "(%d+)'))
end

function M.check()
  -- Mason's bin directory is only on PATH once Mason has loaded
  pcall(function()
    require("lazy").load({ plugins = { "mason.nvim" } })
  end)

  vim.health.start("Neovim")
  if vim.fn.has("nvim-0.11") == 1 then
    vim.health.ok("Neovim " .. tostring(vim.version()))
  else
    vim.health.error("Neovim 0.11 or newer is required", "see Step 0 of the setup notes")
  end

  for _, group in ipairs(groups) do
    vim.health.start(group.title)
    for _, item in ipairs(group.items) do
      local exe, purpose, nix, other = item[1], item[2], item[3], item[4]
      if vim.fn.executable(exe) == 1 then
        vim.health.ok(exe)
      else
        local hint = is_nixos and ("add `" .. nix .. "` to your Nix packages") or other
        local msg = exe .. " not found (" .. purpose .. ")"
        if item.nix_only and not is_nixos then
          vim.health.info(msg .. " - Nix-only tool, skipped on this machine")
        elseif group.level == "error" then
          vim.health.error(msg, hint)
        else
          vim.health.warn(msg, hint)
        end
      end
    end
  end

  vim.health.start("Java runtime")
  local major = java_major()
  if not major then
    vim.health.info("java not found, or version not readable")
  elseif major >= 21 then
    vim.health.ok("Java " .. major .. " (jdtls needs 21+)")
  else
    vim.health.warn(
      "Java " .. major .. " found, but jdtls needs 21+",
      "start nvim with a JDK 21+ on PATH"
    )
  end

  vim.health.start("Clipboard")
  if
    vim.fn.executable("wl-copy") == 1
    or vim.fn.executable("xclip") == 1
    or vim.fn.executable("xsel") == 1
  then
    vim.health.ok("clipboard provider found")
  else
    vim.health.warn("no clipboard provider", "install wl-clipboard (Wayland) or xclip (X11)")
  end

  vim.health.start("Fonts")
  vim.health.info(
    "Nerd Font can't be detected from Neovim. If icons look broken, install one on the machine running your terminal."
  )
end

return M
