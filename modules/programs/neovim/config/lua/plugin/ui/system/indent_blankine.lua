local icon = require("util.icon")

return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  ---@module 'ibl'
  ---@type ibl.config
  opts = {
    indent = {
      char = icon.ui.indent,
    },
    viewport_buffer = {
      min = 500,
    },
    scope = {
      show_start = false,
      show_end = false,
      include = {
        -- NOTE: Allow scope highlighting on all the nodes
        -- [Relevant issue](https://github.com/lukas-reineke/indent-blankline.nvim/issues/632#issuecomment-2577024766)
        node_type = {
          ["*"] = { "*" },
        },
      },
    },
  },
  event = "VeryLazy",
}
