return {
  {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    config = function()
      require("nightfox").setup({
        groups = {
          all = {
            WinSeparator = { bg = "#3a3a3a", fg = "#cccccc" },
          },
          nightfox = {
            IndentLine = { fg = "#3b4252" },
            IndentLineCurrent = { fg = "#5e81ac" },
            CursorLine = { bg = "#3b4252" },
          },
          dayfox = {
            IndentLine = { fg = "#d8dee9" },
            IndentLineCurrent = { fg = "#81a1c1" },
            CursorLine = { bg = "#e6e6e6" },
          },
        },
      })
      vim.cmd.colorscheme("nightfox")
    end,
  },

  { "nvim-tree/nvim-web-devicons" },

  {
    "f-person/auto-dark-mode.nvim",
    opts = {
      set_dark_mode = function()
        vim.cmd("colorscheme nightfox")
        require("bufferline").setup({
          options = { themable = false },
          highlights = {
            background = { fg = "#cdd6f4", bg = "#1e1e2e" },
            buffer_selected = { fg = "#cdd6f4", bg = "#313244", bold = true },
            buffer_visible = { fg = "#cdd6f4", bg = "#1e1e2e" },
          }
        })
      end,
      set_light_mode = function()
        vim.cmd("colorscheme dayfox")
        require("bufferline").setup({
          options = { themable = false },
          highlights = {
            background = { fg = "#3c3836", bg = "#fbf1c7" },
            buffer_selected = { fg = "#3c3836", bg = "#ebdbb2", bold = true },
            buffer_visible = { fg = "#88c0d0", bg = "#fbf1c7" },
          }
        })
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

  -- disabled because slows down
  -- displays indentation rulers
  -- {
  --   "nvimdev/indentmini.nvim",
  --   opts = {
  --     current = true,
  --     minlevel = 2,
  --   },
  -- },
}
