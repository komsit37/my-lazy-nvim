if not vim.g.vscode then
  local wk = require("which-key")
  -- Register terminal group with Nerd Font icon
  wk.add({ "<leader>h", group = "Buffer" })

  -- Git which-key icons
  wk.add({
    { "<leader>gb", desc = "Branches", icon = { icon = "", color = "orange" } },
    { "<leader>gB", desc = "Browse", icon = { icon = "", color = "grey" } },
    { "<leader>gc", desc = "Commit", icon = { icon = "", color = "green" } },
    { "<leader>gC", desc = "Commit (amend)", icon = { icon = "", color = "green" } },
    { "<leader>gs", desc = "Status", icon = { icon = "", color = "green" } },
    { "<leader>gu", desc = "Log (quick)", icon = { icon = "󰜘", color = "yellow" } },
    { "<leader>go", desc = "Log File (quick)", icon = { icon = "󰋚", color = "yellow" } },
    { "<leader>gi", desc = "Log Line", icon = { icon = "", color = "yellow" } },
    { "<leader>gd", desc = "Diff (hunks)", icon = { icon = "", color = "red" } },
    { "<leader>gS", desc = "Stash", icon = { icon = "", color = "yellow" } },
    --diffview
    { "<leader>gv", desc = "Diffview", icon = { icon = "", color = "red" } },
    { "<leader>gV", desc = "Diffview (branch)", icon = { icon = "", color = "red" } },
    { "<leader>gU", desc = "Log", icon = { icon = "󰜘", color = "red" } },
    { "<leader>gO", desc = "Log File", icon = { icon = "󰋚", color = "red" } },
    { "<leader>gx", desc = "Close diffview", icon = { icon = "", color = "grey" } },
    --file navigation
    { "<leader>r", LazyVim.pick("oldfiles"), desc = "Recent", icon = { icon = "󰈙", color = "blue" } },
    {
      "<leader>R",
      function()
        Snacks.picker.recent({ filter = { cwd = true } })
      end,
      desc = "Recent (cwd)",
    },
  })

  -- jump to buffer by number
  local bufferline = require("bufferline")
  for i = 1, 9 do
    wk.add({
      "<leader>" .. i,
      function()
        bufferline.go_to(i, true)
      end,
      -- omit desc so it won't show up in which-key
    })
  end

  vim.keymap.set("n", "<leader>bH", function()
    bufferline.go_to(1, true)
  end, { desc = "Go to first buffer" })

  vim.keymap.set("n", "<leader>bL", function()
    bufferline.go_to(-1, true)
  end, { desc = "Go to last buffer" })
end

vim.keymap.set("n", "<leader>go", function()
  Snacks.picker.git_log_file()
end)
vim.keymap.set("n", "<leader>gu", function()
  Snacks.picker.git_log()
end)

-- add centering on vertical movements for smooth scrolling
local opts = { noremap = true, silent = true }

-- add centering on vertical movements for smooth scrolling
vim.keymap.set("n", "j", "jzz", opts)
vim.keymap.set("n", "k", "kzz", opts)
vim.keymap.set("n", "{", "{zz", opts)
vim.keymap.set("n", "}", "}zz", opts)
vim.keymap.set("n", "<C-j>", "<C-d>zz", opts) -- half-page down + center
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts) -- half-page up + center

-- Code

-- Don't let small deletes overwrite your last yank
vim.keymap.set("n", "x", '"_x', opts) -- delete char (no yank)
vim.keymap.set("n", "X", '"_X', opts) -- delete backward char (no yank)

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

vim.keymap.set("n", "<leader>gi", function()
  Snacks.picker.git_log_line()
end)

-- copy location to system clipboard (for llm)
-- Copy file:line:col + context (selected text or word under cursor)
local function copy_location_with_context()
  local filepath = vim.fn.expand("%:p")
  local line = vim.fn.line(".")
  local col = vim.fn.col(".")

  -- Try git root first
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if vim.v.shell_error == 0 and git_root and git_root ~= "" then
    filepath = filepath:gsub("^" .. vim.pesc(git_root .. "/"), "")
  else
    -- fallback to relative to cwd
    filepath = vim.fn.fnamemodify(filepath, ":.")
  end

  -- Detect visual selection
  local mode = vim.fn.mode()
  local context = ""
  if mode:match("[vV]") then
    -- Get visual selection
    local _, ls, cs = unpack(vim.fn.getpos("'<"))
    local _, le, ce = unpack(vim.fn.getpos("'>"))
    local lines = vim.fn.getline(ls, le)
    if #lines > 0 then
      lines[#lines] = string.sub(lines[#lines], 1, ce)
      lines[1] = string.sub(lines[1], cs)
      context = table.concat(lines, "\n")
    end
  else
    -- fallback: word under cursor
    context = vim.fn.expand("<cword>")
  end

  local result = string.format("%s:%d:%d %s", filepath, line, col, context)
  vim.fn.setreg("+", result) -- copy to system clipboard
  print("Copied: " .. result)
end

-- Map in normal and visual mode
vim.keymap.set({ "n", "v" }, "<leader>yc", copy_location_with_context, { desc = "Copy file:line:col + context" })

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
