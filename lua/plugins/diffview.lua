-- Get formatted git status file list
local function get_git_status_list()
  -- Get staged files
  local staged_result = vim.system({ "git", "diff", "--cached", "--name-status" }, { text = true }):wait()
  local staged_files = staged_result.stdout and vim.trim(staged_result.stdout) or ""

  -- Get unstaged files
  local unstaged_result = vim.system({ "git", "diff", "--name-status" }, { text = true }):wait()
  local unstaged_files = unstaged_result.stdout and vim.trim(unstaged_result.stdout) or ""

  -- Format file list
  local file_list = ""
  if staged_files ~= "" then
    file_list = file_list .. "Staged changes:\n" .. staged_files
  end
  if unstaged_files ~= "" then
    if file_list ~= "" then
      file_list = file_list .. "\n\n"
    end
    file_list = file_list .. "Unstaged changes:\n" .. unstaged_files
  end
  if file_list == "" then
    file_list = "No changes to commit"
  end

  return file_list
end

-- Git commit utility function
local function git_commit()
  -- Show file list before prompting
  -- vim.notify(get_git_status_list(), "info", {
  --   id = 1,
  --   title = "Git Status",
  --   timeout = 0,
  -- })
  local top_padding = "\n\n\n\n"
  local win = Snacks.win({ text = top_padding .. get_git_status_list(), width = 0.6, hdeight = 0.6, border = "hpad" })

  require("snacks").input({
    prompt = "git commit -m ",
  }, function(msg)
    -- Close the status notifier when input finishes
    -- require("snacks").notifier.hide(1)
    win:close()

    if not msg or msg == "" then
      return
    end

    local result = vim.system({ "git", "commit", "-m", msg }, { text = true }):wait()
    if result.code ~= 0 then
      Snacks.notify.error(
        "Commit failed:\n" .. vim.trim(result.stdout .. "\n" .. result.stderr),
        { title = "Git Commit" }
      )
    else
      Snacks.notify.info(result.stdout, { title = "Git Commit" })
    end
  end)
end

-- Git commit amend utility function
local function git_commit_amend()
  -- Show file list before prompting
  local top_padding = "\n\n\n\n"
  local win = Snacks.win({ text = top_padding .. get_git_status_list(), width = 0.6, hdeight = 0.6, border = "hpad" })

  require("snacks").input({ prompt = "Amend message (leave empty to reuse): " }, function(msg)
    -- Close the status window when input finishes
    win:close()
    local cmd = { "git", "commit", "--amend" }
    if msg and msg ~= "" then
      table.insert(cmd, "-m")
      table.insert(cmd, msg)
    end

    local result = vim.system(cmd, { text = true }):wait()
    if result.code ~= 0 then
      vim.notify(
        "Amend failed:\n" .. vim.trim(result.stdout .. "\n" .. result.stderr),
        vim.log.levels.ERROR,
        { title = "Git Commit Amend" }
      )
    else
      vim.notify(result.stdout, vim.log.levels.INFO, { title = "Git Commit Amend" })
    end
  end)
end

return {
  "sindrets/diffview.nvim",
  dependencies = { "ray-x/snacks.nvim" },
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFileHistory",
  },
  keys = {
    { "<leader>gv", "<cmd>DiffviewOpen<cr>" },

    {
      "<leader>gV",
      function()
        require("snacks.picker").git_branches({
          prompt = "Select branch to diff with",
          confirm = function(picker, item)
            picker:close()
            vim.cmd("DiffviewOpen " .. item.text)
          end,
        })
      end,
    },

    { "<leader>gO", "<cmd>DiffviewFileHistory %<cr>" },
    { "<leader>gU", "<cmd>DiffviewFileHistory<cr>" },
    { "<leader>gx", "<cmd>DiffviewClose<cr>" },
    { "<leader>gc", git_commit },
    { "<leader>gC", git_commit_amend },
  },
  config = function()
    require("diffview").setup({
      keymaps = {
        file_panel = {
          { "n", "cc", git_commit, desc = "Commit (custom)" },
          { "n", "ca", git_commit_amend, desc = "Commit Amend (custom)" },
        },
      },
    })
  end,
}
