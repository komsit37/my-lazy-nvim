if vim.g.vscode then
  return {}
else
  return {
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        preset = "modern",
      },
    },
  }
end
