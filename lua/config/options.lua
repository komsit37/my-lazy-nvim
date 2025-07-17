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
-- To yank to system clipboard explicitly, use the + register:
--   "+yy   - yank current line to system clipboard
--   "+y    - yank visual selection to system clipboard
--
-- Since clipboard = "unnamedplus" is disabled,
-- Neovim won't auto-sync yanks to system clipboard,
-- so you must use "+ before yank commands to copy externally.

-- vim.o.clipboard = "unnamedplus"
vim.opt.clipboard = ""

-- do not show / in diff delete lines
vim.opt.fillchars = "diff: "
