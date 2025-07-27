return {
  {
    lazy = true,
     "nvim-lua/plenary.nvim"
  },

  -- persist sessions
  {
    "rmagatti/auto-session",
    lazy = false,
    opts = {
      suppressed_dirs = { "~/Downloads", "/" },
    },
  },

  -- shortcuts help tooltip that appears upon pressing a key with a short delay
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
  },

  -- -- {
  -- --   "lukas-reineke/indent-blankline.nvim",
  -- --   event = { "BufReadPre", "BufNewFile" },
  -- --   config = function()
  -- --     require("ibl").setup({
  -- --       indent = { char = "│" },
  -- --       scope = { char = "│", highlight = "Comment" },
  -- --     })
  -- --   end,
  -- -- },


}
