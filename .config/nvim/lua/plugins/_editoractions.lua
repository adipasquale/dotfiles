return {

  -- ysiw'   = you surround inner word with '
  -- ds[       delete surrounding brackets
  {
    "kylechui/nvim-surround",
    version = "*",
    config = function()
      require("nvim-surround").setup({})
    end,
  },

  {
    "mg979/vim-visual-multi",
    init = function()
      vim.g.VM_maps = {
        ["Add Cursor Down"] = "<C-S-j>",
        ["Add Cursor Up"] = "<C-S-k>",
      }
    end,
  },

  {
    "victormours/ruby-memoize.vim",
  },

  -- gS and gJ to toggle between multi-line and single line method call
  {
    "AndrewRadev/splitjoin.vim",
  },

  -- -- fix :W typo
  -- -- disabled because it breaks GBrowse
  -- -- {
  -- --   "gcmt/cmdfix.nvim",
  -- --   config = function()
  -- --     require("cmdfix").setup({
  -- --       enabled = true,
  -- --       ignore = { "GBrowse" },
  -- --     })
  -- --   end,
  -- -- },
}
