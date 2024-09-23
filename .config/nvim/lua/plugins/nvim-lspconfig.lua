local util = require("lspconfig").util
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ruby_lsp = {
        mason = false,
        cmd = { vim.fn.expand("~/.rbenv/shims/ruby-lsp") },
      },
      rubocop = {
        cmd = { "bundle", "exec", "rubocop", "--lsp" },
        root_dir = util.root_pattern("Gemfile", ".git"),
      },
    },
  },
}
