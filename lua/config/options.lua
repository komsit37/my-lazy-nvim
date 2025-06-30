-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- -- fix clipboard hanging when usig wezterm with ssh
-- vim.g.clipboard = {
--   name = "OSC 52",
--   copy = {
--     ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
--     ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
--   },
--   paste = {
--     ["+"] = function()
--       return { vim.fn.split(vim.fn.getreg('"'), "\n"), vim.fn.getregtype('"') }
--     end,
--     ["*"] = function()
--       return { vim.fn.split(vim.fn.getreg('"'), "\n"), vim.fn.getregtype('"') }
--     end,
--   },
-- }

-- do not copy to system clipboard, so I can use two clipboard
-- vim.o.clipboard = "unnamedplus"
vim.opt.clipboard = ""

-- To yank to system clipboard explicitly, use the + register:
--   "+yy   - yank current line to system clipboard
--   "+y    - yank visual selection to system clipboard
--
-- Since clipboard = "unnamedplus" is disabled,
-- Neovim won't auto-sync yanks to system clipboard,
-- so you must use "+ before yank commands to copy externally.

-- Define system sounds for each mode (macOS built-in)
local mode_sounds = {
  n = "/System/Library/Sounds/Glass.aiff", -- Normal mode
  i = "/System/Library/Sounds/Hero.aiff", -- Insert mode
  v = "/System/Library/Sounds/Bottle.aiff", -- Visual mode
  V = "/System/Library/Sounds/Bottle.aiff", -- Visual Line
  ["\22"] = "/System/Library/Sounds/Bottle.aiff", -- Visual Block (Ctrl+V)
  c = "/System/Library/Sounds/Ping.aiff", -- Command mode (:)
}

vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "*",
  callback = function(args)
    local to_mode = args.match:sub(-1)
    if to_mode ~= last_mode then
      local sound = mode_sounds[to_mode]
      if sound then
        vim.fn.jobstart({ "afplay", sound }, { detach = true })
      end
      last_mode = to_mode
    end
  end,
})
