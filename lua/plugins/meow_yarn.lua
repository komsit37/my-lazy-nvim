-- https://github.com/retran/meow.yarn.nvim
return {
  "retran/meow.yarn.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  config = function()
    require("meow.yarn").setup({
      -- Your custom configuration goes here
    })
  end,
  keys = {
    {
      "<leader>cit",
      function()
        require("meow.yarn").open_tree("type_hierarchy", "supertypes")
      end,
      desc = "Yarn: Type Hierarchy (Super)",
      mode = "n",
    },
    {
      "<leader>ciT",
      function()
        require("meow.yarn").open_tree("type_hierarchy", "subtypes")
      end,
      desc = "Yarn: Type Hierarchy (Sub)",
      mode = "n",
    },
    {
      "<leader>cic",
      function()
        require("meow.yarn").open_tree("call_hierarchy", "callers")
      end,
      desc = "Yarn: Call Hierarchy (Callers)",
      mode = "n",
    },
    {
      "<leader>ciC",
      function()
        require("meow.yarn").open_tree("call_hierarchy", "callees")
      end,
      desc = "Yarn: Call Hierarchy (Callees)",
      mode = "n",
    },
  },
}
