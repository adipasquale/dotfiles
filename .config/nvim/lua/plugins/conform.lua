
return {
  -- This will provide type hinting with LuaLS
  {
    "stevearc/conform.nvim",
    lazy = true,
    opts = {
      formatters = {
        prettier = {
          command = "node_modules/prettier/bin/prettier.cjs",
        },
        stylua = {
          prepend_args = { "--indent-type", "Spaces", "--indent-width", "2", "--column-width", "160" },
        },
      },
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettier" },
        scss = { "prettier" },
      },
    },
  },
}
