return {
  -- Mason is a LSP package manager : installs, updates
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonInstall" },
    opts = {},
  },

  -- default configs for LSP
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- we skip Mason for ruby lsp and Rubocop because it’s installed through bundler and rbenv
      -- cf https://github.com/mason-org/mason.nvim/issues/1776
      vim.lsp.config("ruby_lsp", {
        init_options = {
          enabledFeatures = {
            signatureHelp = true,
            -- formatting = false,
          },
          addonSettings = {
            ["Ruby LSP Rails"] = {
              enablePendingMigrationsPrompt = false,
            },
          },
        },
      })
      vim.lsp.enable("ruby_lsp")
      -- vim.lsp.enable("rubocop")
    end,
  },

  -- allows written config of LSP to install with mason
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "gh_actions_ls",
          "html",
          "ts_ls",
        },
      })
    end,
  },
}
