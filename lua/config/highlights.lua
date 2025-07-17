-- set highlight for vim illuminate
local function set_illuminate_highlights()
  vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "#3a4b3a", underline = true })
  vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#553333", underline = true })
  vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = "#333355", underline = true })
end

-- set diff highlights
local function set_diff_highlights()
  -- print("Setting diff highlights...")
  vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#ffffff", bg = "#7f2b37" })
  vim.api.nvim_set_hl(0, "DiffAdd", { fg = "#ffffff", bg = "#295c2b" })
  vim.api.nvim_set_hl(0, "DiffChange", { fg = "#ffffff", bg = "#4a3f2c" })
  -- print("Diff highlights set")
end

-- Set once on startup
set_illuminate_highlights()
set_diff_highlights()

-- Reapply on ColorScheme change
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    set_illuminate_highlights()
    set_diff_highlights()
  end,
})
