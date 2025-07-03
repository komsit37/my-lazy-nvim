-- better yank/paste
return {
  "gbprod/yanky.nvim",
  keys = {
    -- remap to <leader>h so we can use <leader>p for paste from system history
    { "<leader>p", false, mode = { "n", "x" } },
    {
      "<leader>h",
      function()
        if LazyVim.pick.picker.name == "telescope" then
          require("telescope").extensions.yank_history.yank_history({})
        else
          vim.cmd([[YankyRingHistory]])
        end
      end,
      mode = { "x" },
      desc = "Open Yank History",
    },
  },
}
