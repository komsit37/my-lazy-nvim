-- For `plugins/markview.lua` users.
return {
  "OXY2DEV/markview.nvim",
  lazy = true,

  -- to fix warning nvim-treesitter  is being loaded before  markview.nvim
  priority = 1000, -- Higher priority than treesitter
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  -- For blink.cmp's completion
  -- source
  -- dependencies = {
  --     "saghen/blink.cmp"
  -- },
}
