-- files finder etc
return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-telescope/telescope-live-grep-args.nvim",
      "folke/trouble.nvim",
      version = "^1.0.0",
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local open_with_trouble = require("trouble.sources.telescope").open
      telescope.setup({
        defaults = {
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = { prompt_position = "top" },
          },
          layout_strategy = "vertical",
          mappings = {
            i = {
              ["<S-Down>"] = actions.cycle_history_next,
              ["<S-Up>"] = actions.cycle_history_prev,
              ["<c-t>"] = open_with_trouble,
            },
            n = { ["<c-t>"] = open_with_trouble },
          },
        },
      })
      telescope.load_extension("live_grep_args")

      vim.keymap.set("n", "<leader><leader>", "<cmd> Telescope find_files <CR>")
      vim.keymap.set("n", "<leader>ff", "<cmd> Telescope find_files <CR>")
      vim.keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
      vim.keymap.set("n", "<leader>fb", "<cmd> Telescope buffers<CR>")
      vim.keymap.set("n", "<leader>fs", "<cmd> Telescope git_status <CR>")
    end,
  },

  -- useful for LSP config code actions <leader>ca
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      require("telescope").load_extension("ui-select")
    end,
  },
}
