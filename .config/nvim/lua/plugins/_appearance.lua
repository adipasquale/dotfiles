return {
  {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "nightfox"
    end
  },

  { "nvim-tree/nvim-web-devicons" },

  {
    "f-person/auto-dark-mode.nvim",
    opts = {
      set_dark_mode = function()
        vim.cmd("colorscheme nightfox")
        -- vim.api.nvim_set_option_value("background", "dark", {})
      end,
      set_light_mode = function()
        vim.cmd("colorscheme dayfox")
        -- vim.api.nvim_set_option_value("background", "light", {})
      end,
      update_interval = 3000,
      fallback = "dark",
    },
  },

  -- these are the tabs at the top of the screen (i think)
  {
    "akinsho/bufferline.nvim",
    event = "BufReadPre",
    opts = {
      options = {
        themable = true,
        offsets = {
          { filetype = "NvimTree", highlight = "NvimTreeNormal" },
        },
      },
    },
    dependencies = "nvim-tree/nvim-web-devicons",
    lazy = false,
  },

  {
    "echasnovski/mini.statusline",
    config = function()
      require("mini.statusline").setup({ set_vim_settings = false })
    end,
  },


  -- disabled because it slows down YAML
  -- -- indent guides
  -- -- {
  -- --   "nvimdev/indentmini.nvim",
  -- --   config = function()
  -- --     require("indentmini").setup() -- use default config
  -- --   end,
  -- -- },
}
