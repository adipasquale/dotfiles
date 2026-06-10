return {
  -- treesitter for syntax highlighting and more
  {
    "nvim-treesitter/nvim-treesitter",
    -- init = function()
    --   local ensureInstalled = { "lua", "vim", "vimdoc", "html", "css", "typescript", "javascript", "ruby" }
    --   local alreadyInstalled = require("nvim-treesitter.config").get_installed()
    --   local parsersToInstall = vim
    --     .iter(ensureInstalled)
    --     :filter(function(parser)
    --       return not vim.tbl_contains(alreadyInstalled, parser)
    --     end)
    --     :totable()
    --   require("nvim-treesitter").install(parsersToInstall)
    -- end,
  },

  -- new text objects like if for inside function
  -- {
  --   "nvim-treesitter/nvim-treesitter-textobjects",
  --   dependencies = "nvim-treesitter/nvim-treesitter",
  --   config = function()
  --     require("nvim-treesitter.configs").setup({
  --
  --       textobjects = {
  --         select = {
  --           enable = true,
  --           keymaps = {
  --             ["af"] = "@function.outer",
  --             ["if"] = "@function.inner",
  --             ["ac"] = "@class.outer",
  --             ["ic"] = "@class.inner",
  --             ["al"] = "@loop.outer",
  --             ["il"] = "@loop.inner",
  --           },
  --           include_surrounding_whitespace = true,
  --         },
  --       },
  --     })
  --   end,
  -- },
}
