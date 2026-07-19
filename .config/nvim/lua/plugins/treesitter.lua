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

  -- new text objects like af for around function, if for inside function
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      local select = require("nvim-treesitter-textobjects.select")
      local keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
      }
      for key, query in pairs(keymaps) do
        vim.keymap.set({ "x", "o" }, key, function()
          select.select_textobject(query, "textobjects")
        end)
      end
    end,
  },
}
