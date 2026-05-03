return {
  {
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons", -- optional, but recommended
      },
      lazy = false, -- neo-tree will lazily load itself
      config = function()
        vim.keymap.set("n", "<leader>fe", ":Neotree filesystem reveal left <CR>", {})
      end,
    },
  },

  {
    "echasnovski/mini.nvim",
    version = "*",
    config = function()
      vim.keymap.set("n", "<leader>fm", function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
      end, { desc = "Open mini.files (Directory of Current File)" })
      vim.keymap.set("n", "<leader>fM", function()
        require("mini.files").open(vim.uv.cwd(), true)
      end, { desc = "Open mini.files (cwd)" })
    end,
  },

  -- flash.nvim lets you navigate your code with search labels, enhanced character motions, and Treesitter integration.
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = { modes = { search = { enabled = true } } },
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  -- close all buffers but current one with :BufDelOthers
  {
    "ojroques/nvim-bufdel",
    config = function()
      require("bufdel").setup({
        quit = false,
      })
    end,
  },
}
