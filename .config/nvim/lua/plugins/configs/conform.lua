return {
  formatters = {
    prettier = {
      command = "node_modules/prettier/bin/prettier.cjs"
    }
  },
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettier" },
    scss = { "prettier" }
  },
}
