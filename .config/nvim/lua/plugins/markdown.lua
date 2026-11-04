return {
  -- markdown preview rendered in the terminal (inline images via Kitty Graphics Protocol)
  -- requires Neovim >= 0.12 and a compatible terminal (kitty / WezTerm / Ghostty)
  {
    "delphinus/md-render.nvim",
    version = "*",
    event = { "VeryLazy" },
    config = function()
      -- preview tab = full window width (default cap is 80 cols, which also
      -- caps inline image width since images are scaled to the render width)
      vim.g.md_render_max_width = 300
      -- image height caps are hardcoded in the plugin (25 rows outside tables,
      -- 15 inside) and squash tall full-page screenshots to ~15-25 rows; raise them
      local image = require("md-render.image")
      local orig_calc = image.calc_display_size
      image.calc_display_size = function(img_w, img_h, max_cols, max_rows)
        return orig_calc(img_w, img_h, max_cols, math.max(max_rows, 30))
      end
    end,
    keys = {
      { "<leader>mt", "<Plug>(md-render-preview-tab)", desc = "Markdown preview in tab (toggle)" },
    },
  },
}
