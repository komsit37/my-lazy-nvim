-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Define system sounds for each mode (macOS built-in)
-- osx old sound is snappier
local mode_sounds = {
  n = "/System/Library/Sounds/Morse.aiff", -- Normal mode
  i = "/Users/pkomsit/dotfiles/osx-old-sounds/Hero.aiff", -- Insert mode
  v = "/System/Library/Sounds/Purr.aiff", -- Visual mode
  V = "/System/Library/Sounds/Purr.aiff", -- Visual Line
  ["\22"] = "/System/Library/Sounds/Purr.aiff", -- Visual Block (Ctrl+V)
  c = "/System/Library/Sounds/Ping.aiff", -- Command mode (:)
}
local is_remote = os.getenv("SSH_CONNECTION") ~= nil or os.getenv("SSH_CLIENT") ~= nil
local last_mode = vim.fn.mode()
-- throttle
local last_play = 0
local min_gap = 100 -- ms
if not is_remote then
  vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = "*",
    callback = function(args)
      local to_mode = args.match:sub(-1)
      if to_mode ~= last_mode then
        local sound = mode_sounds[to_mode]
        if sound then
          local now = vim.loop.now()
          if now - last_play > min_gap then
            vim.fn.jobstart({ "play", "-q", sound }, { detach = true })
            last_play = now
          end
        end
        last_mode = to_mode
      end
    end,
  })
end

---------------------------------------------------
-- auto chdir to opening dir
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local arg = vim.fn.argv(0)
    if arg ~= "" and vim.fn.isdirectory(arg) == 1 then
      vim.cmd("cd " .. arg)
    end
  end,
  desc = "CD into directory if nvim launched with one",
})

-- Function to rename tmux window based on nvim arguments
local function rename_tmux_window_on_startup()
  if not vim.env.TMUX then
    return
  end

  local args = vim.fn.argv()
  local name

  if #args > 0 then
    local arg = args[1]
    if vim.fn.isdirectory(arg) == 1 then
      local dir_path = arg == "." and vim.fn.getcwd() or arg
      name = vim.fn.fnamemodify(dir_path, ":t")
    else
      name = vim.fn.fnamemodify(arg, ":t:r")
    end
  else
    name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  end

  if name ~= "" then
    vim.fn.system("tmux rename-window " .. vim.fn.shellescape("v:" .. name))
  end
end

-- Rename only on nvim startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = rename_tmux_window_on_startup,
  desc = "Rename tmux window based on nvim arguments",
})

-- Function to restore tmux window name on exit
local function restore_tmux_window_on_exit()
  if not vim.env.TMUX then
    return
  end

  -- Rename back to directory name
  local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  vim.fn.system("tmux rename-window " .. vim.fn.shellescape(dir_name))
end

-- Restore on nvim exit
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = restore_tmux_window_on_exit,
  desc = "Restore tmux window name on nvim exit",
})

-- Go file specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.expandtab = false -- use tabs, not spaces
    vim.opt_local.tabstop = 4 -- show a tab as 4 spaces
    vim.opt_local.shiftwidth = 4 -- indent/outdent by 4
    vim.opt_local.softtabstop = 4 -- tab feels like 4 spaces
  end,
})

-- Short alias for MarkdownPreview command
vim.api.nvim_create_user_command("Mdp", function()
  vim.cmd("MarkdownPreview")
end, { desc = "Alias for MarkdownPreview" })
