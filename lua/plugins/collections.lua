local HOME = os.getenv("HOME")
return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          args = { "--config", HOME .. "/.config/nvim/markdownlint-cli2.yaml", "--" },
        },
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        numbers = function(opts)
          return string.format("[%d]", opts.ordinal)
        end,
      },
    },
  },
  {
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
  },
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      notifier = {
        -- your notifier configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        timeout = 5000, -- default timeout in ms
      },
    },
  },
  {
    "dstein64/nvim-scrollview",
    event = "VeryLazy",
  },
  {
    "shahshlok/vim-coach.nvim",
    dependencies = {
      "folke/snacks.nvim",
    },
    config = function()
      require("vim-coach").setup()
    end,
    keys = {
      { "<leader>?", "<cmd>VimCoach<cr>", desc = "Vim Coach" },
    },
  },
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
  },
}
