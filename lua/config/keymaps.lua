-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

if not vim.g.vscode then
  local wk = require("which-key")
  -- Register terminal group with Nerd Font icon
  wk.add({ "<leader>t", group = "Terminal" })

  -- Git which-key icons
  wk.add({
    { "<leader>gb", desc = "Git Branches", icon = { icon = "", color = "orange" } },
    { "<leader>gs", desc = "Git Status", icon = { icon = "", color = "green" } },
    { "<leader>gl", desc = "Git Log", icon = { icon = "󰜘", color = "yellow" } },
    { "<leader>gf", desc = "Git Log File", icon = { icon = "󰋚", color = "yellow" } },
    { "<leader>gi", desc = "Git Log Line", icon = { icon = "", color = "yellow" } },
    { "<leader>gd", desc = "Git Diff (hunks)", icon = { icon = "", color = "red" } },
    { "<leader>gS", desc = "Git Stash", icon = { icon = "", color = "yellow" } },
  })
end

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

if not vim.g.vscode then
  vim.keymap.set("n", "<leader>ce", function()
    require("metals").reveal_in_tree()
  end, { desc = "Reveal in tree" })
end

-- Git keymaps (Snacks.nvim)
vim.keymap.set("n", "<leader>gb", function()
  Snacks.picker.git_branches()
end)

vim.keymap.set("n", "<leader>gl", function()
  Snacks.picker.git_log()
end)

vim.keymap.set("n", "<leader>gf", function()
  Snacks.picker.git_log_file()
end)

vim.keymap.set("n", "<leader>gi", function()
  Snacks.picker.git_log_line()
end)
