-- set highlight for vim illuminate
local function set_illuminate_highlights()
  vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "#3a4b3a", underline = true })
  vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#553333", underline = true })
  vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = "#333355", underline = true })
end

-- Set once on startup
set_illuminate_highlights()

-- Reapply on ColorScheme change
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_illuminate_highlights,
})
