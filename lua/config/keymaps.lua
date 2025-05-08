-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local wk = require("which-key")

-- Register terminal group with Nerd Font icon
wk.add({ "<leader>t", group = "Terminal" })

vim.keymap.set("n", "<leader>tt", function()
  Snacks.terminal.toggle()
end, { desc = "Toggle Snacks Terminal" })
vim.keymap.set("n", "<leader>tf", function()
  Snacks.terminal.toggle(nil, { win = { style = "float" } })
end, { desc = "Toggle Snacks Terminal (Float)" })
