return {
  -- Mason is a LSP package manager : installs, updates
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonInstall" },
    opts = {},
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
          "rubocop",
          "ruby_lsp",
          "ts_ls",
        },
        -- hack required to have ruby-lsp work with rbenv
        ruby_lsp = function()
          require("lspconfig").ruby_lsp.setup({
            cmd = { os.getenv("HOME") .. "/.rbenv/shims/ruby-lsp" },
          })
        end,
      })
    end,
  },

  -- default configs for LSP
  {
    "neovim/nvim-lspconfig",
  },
}
