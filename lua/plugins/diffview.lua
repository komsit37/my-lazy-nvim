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
    { "<leader>gv", group = "Git Diffview" },

    { "<leader>gvd", "<cmd>DiffviewOpen<cr>", desc = "Open Diff View" },

    {
      "<leader>gvD",
      function()
        require("snacks.picker").git_branches({
          prompt = "Select branch to diff with",
          confirm = function(picker, item)
            picker:close()
            vim.cmd("DiffviewOpen " .. item.text)
          end,
        })
      end,
      desc = "Diff with Branch",
    },

    { "<leader>gvh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History (Current File)" },
    { "<leader>gvH", "<cmd>DiffviewFileHistory<cr>", desc = "File History (Current Branch)" },
    { "<leader>gvx", "<cmd>DiffviewClose<cr>", desc = "Close Diff View" },
  },
  config = function()
    require("diffview").setup({
      keymaps = {
        file_panel = {
          {
            "n",
            "cc",
            function()
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
            end,
            desc = "Commit (custom)",
          },
          {
            "n",
            "ca",
            function()
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
            end,
            desc = "Commit Amend (custom)",
          },
        },
      },
    })
  end,
}
