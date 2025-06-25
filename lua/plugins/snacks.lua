return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    opts.git = opts.git or {}
    opts.git.enabled = true
    return opts
  end,
  keys = {
    {
      "<leader>gb",
      function()
        Snacks.picker.git_branches()
      end,
      desc = "Git Branches",
    },
    {
      "<leader>gl",
      function()
        Snacks.picker.git_log()
      end,
      desc = "Git Log",
    },
    {
      "<leader>gf",
      function()
        Snacks.picker.git_log_file()
      end,
      desc = "Git Log File",
    },
    {
      "<leader>gi",
      function()
        Snacks.picker.git_log_line()
      end,
      desc = "Git Log Line",
    },
  },

  -- Configure which-key separately for icons
  config = function()
    local wk = require("which-key")
    wk.add({
      -- { "<leader>g", group = " Git", icon = "" },
      { "<leader>gb", desc = "Git Branches", icon = { icon = "", color = "orange" } },
      { "<leader>gl", desc = "Git Log", icon = { icon = "󰜘", color = "yellow" } },
      { "<leader>gf", desc = "Git Log File", icon = { icon = "󰋚", color = "blue" } },
      { "<leader>gi", desc = "Git Log Line", icon = "" },
      { "<leader>gd", desc = "Git Diff (hunks)", icon = { icon = "", color = "red" } },
      { "<leader>gs", desc = "Git Status", icon = { icon = "", color = "green" } },
      { "<leader>gS", desc = "Git Stash", icon = { icon = "", color = "yellow" } },
    })
  end,
}
