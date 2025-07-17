-- Git commit utility function
local function git_commit()
  require("snacks").input({ prompt = "git commit -m " }, function(msg)
    if not msg or msg == "" then
      return
    end

    local result = vim.system({ "git", "commit", "-m", msg }, { text = true }):wait()
    if result.code ~= 0 then
      vim.notify(
        "Commit failed:\n" .. vim.trim(result.stdout .. "\n" .. result.stderr),
        vim.log.levels.ERROR,
        { title = "Git Commit" }
      )
    else
      vim.notify(result.stdout, vim.log.levels.INFO, { title = "Git Commit" })
    end
  end)
end

-- Git commit amend utility function
local function git_commit_amend()
  require("snacks").input({ prompt = "Amend message (leave empty to reuse): " }, function(msg)
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
          {
            "n",
            "cc",
            git_commit,
            desc = "Commit (custom)",
          },
          {
            "n",
            "ca",
            git_commit_amend,
            desc = "Commit Amend (custom)",
          },
        },
      },
    })
  end,
}
