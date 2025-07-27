return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      -- "antoinemadec/FixCursorHold.nvim",
      -- adapters
      "olimorris/neotest-rspec",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-rspec")({
            rspec_cmd = function()
              return vim.tbl_flatten({ "bundle", "exec", "rspec" })
            end,
          }),
        },
      })
    end,
    keys = {
      { "<leader>t", "", desc = "+test" },
      {
        "<leader>tt",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "run file",
      },
      {
        "<leader>tt",
        function()
          require("neotest").run.run(vim.uv.cwd())
        end,
        desc = "run all test files",
      },
      {
        "<leader>tr",
        function()
          require("neotest").run.run()
        end,
        desc = "run nearest",
      },
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "run last",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "toggle summary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "show output",
      },
      {
        "<leader>to",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "toggle output panel",
      },
      {
        "<leader>ts",
        function()
          require("neotest").run.stop()
        end,
        desc = "stop",
      },
      {
        "<leader>tw",
        function()
          require("neotest").watch.toggle(vim.fn.expand("%"))
        end,
        desc = "toggle watch",
      },
    },
  },
}
