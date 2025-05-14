-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local wk = require("which-key")

-- Register terminal group with Nerd Font icon
wk.add({ "<leader>t", group = "Terminal" })

-- Terminal keymaps
vim.keymap.set("n", "<leader>tt", function()
  Snacks.terminal.toggle()
end, { desc = "Toggle Snacks Terminal" })
vim.keymap.set("n", "<leader>tf", function()
  Snacks.terminal.toggle(nil, { win = { style = "float" } })
end, { desc = "Toggle Snacks Terminal (Float)" })

-- Disable defalt terminal keymaps
vim.keymap.del("n", "<leader>ft")
vim.keymap.del("n", "<leader>fT")

-- remap defults movement keys for graphite key layout
vim.keymap.set("n", "j", "jzz", { noremap = true })
vim.keymap.set("n", "k", "kzz", { noremap = true })
vim.keymap.set("n", "<C-j>", "<C-d>zz", { noremap = true }) -- e.g., half-page down + center
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true }) -- e.g., half-page down + center
-- Code
-- Comments
vim.keymap.set("n", "<leader>c/", "gcc", { remap = true, desc = "Toggle comment line (gcc)" })
vim.keymap.set("v", "<leader>c/", "gc", { remap = true, desc = "Toggle comment (gc)" })
vim.keymap.set("n", "<leader>cr", function()
  require("metals").reveal_in_tree()
end, { desc = "Reveal in tree" })
