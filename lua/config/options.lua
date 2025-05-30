-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- fix clipboard hanging when usig wezterm with ssh
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = function()
      return { vim.fn.split(vim.fn.getreg('"'), "\n"), vim.fn.getregtype('"') }
    end,
    ["*"] = function()
      return { vim.fn.split(vim.fn.getreg('"'), "\n"), vim.fn.getregtype('"') }
    end,
  },
}
vim.o.clipboard = "unnamedplus"
