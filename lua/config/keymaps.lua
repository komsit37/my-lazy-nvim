if not vim.g.vscode then
  local wk = require("which-key")
  -- Register terminal group with Nerd Font icon
  wk.add({ "<leader>h", group = "Buffer" })

  -- Git which-key icons
  wk.add({
    { "<leader>gb", desc = "Git Branches", icon = { icon = "", color = "orange" } },
    { "<leader>gs", desc = "Git Status", icon = { icon = "", color = "green" } },
    { "<leader>gl", desc = "Git Log", icon = { icon = "󰜘", color = "yellow" } },
    { "<leader>gf", desc = "Git Log File", icon = { icon = "󰋚", color = "yellow" } },
    { "<leader>gi", desc = "Git Log Line", icon = { icon = "", color = "yellow" } },
    { "<leader>gd", desc = "Git Diff (hunks)", icon = { icon = "", color = "red" } },
    { "<leader>gS", desc = "Git Stash", icon = { icon = "", color = "yellow" } },
    { "<leader>r", LazyVim.pick("oldfiles"), desc = "Recent" },
    {
      "<leader>R",
      function()
        Snacks.picker.recent({ filter = { cwd = true } })
      end,
      desc = "Recent (cwd)",
    },
  })
end

-- remap defults movement keys for graphite key layout
vim.keymap.set("n", "j", "jzz", { noremap = true })
vim.keymap.set("n", "k", "kzz", { noremap = true })
vim.keymap.set("n", "<C-j>", "<C-d>zz", { noremap = true }) -- e.g., half-page down + center
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true }) -- e.g., half-page down + center
-- Code
-- Comments
vim.keymap.set("n", "<leader>c/", "gcc", { remap = true, desc = "Toggle comment line (gcc)" })
vim.keymap.set("v", "<leader>c/", "gc", { remap = true, desc = "Toggle comment (gc)" })
-- Yank to system clipboard
vim.keymap.set("v", "<leader>y", '"+y', { desc = 'Yank to system clipboard "+y' })
vim.keymap.set("v", "<leader>p", '"+p', { desc = 'Paste from system clipboard "+p' })

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

-- buffer keymaps
-- buffers
-- vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
-- vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
-- vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
-- vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
-- vim.keymap.set("n", "<leader>hh", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
-- vim.keymap.set("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
-- vim.keymap.set("n", "<leader>hd", function()
--   Snacks.bufdelete()
-- end, { desc = "Delete Buffer" })
-- vim.keymap.set("n", "<leader>ho", function()
--   Snacks.bufdelete.other()
-- end, { desc = "Delete Other Buffers" })
-- vim.keymap.set("n", "<leader>hD", "<cmd>:bh<cr>", { desc = "Delete Buffer and Window" })
--
-- vim.keymap.set("n", "<leader>hp", "<Cmd>BufferLineTogglePin<CR>", { desc = "Toggle Pin" })
-- vim.keymap.set("n", "<leader>hP", "<Cmd>BufferLineGroupClose ungrouped<CR>", { desc = "Delete Non-Pinned Buffers" })
-- vim.keymap.set("n", "<leader>hr", "<Cmd>BufferLineCloseRight<CR>", { desc = "Delete Buffers to the Right" })
-- vim.keymap.set("n", "<leader>hl", "<Cmd>BufferLineCloseLeft<CR>", { desc = "Delete Buffers to the Left" })
